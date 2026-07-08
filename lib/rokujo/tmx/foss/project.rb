require "pathname"
require "rokujo/tmx/foss/downloaders/http"
require "rokujo/tmx/foss/extractors/zip"
require "rokujo/tmx/foss/extractors/tar"
require "rokujo/tmx/foss/logger"
require "shellwords"

module Rokujo
  module TMX
    module FOSS
      # A project
      class Project
        attr_reader :name, :template

        DISTDIRPREFIX = Pathname.pwd / "distfiles"
        WRKDIRPREFIX = Pathname.pwd / "work"
        STAGEDIR = Pathname.pwd / "stage"

        def initialize(**args)
          @name = args[:name]
          @dist_url = args[:dist_url]
          @worksubdir = args[:worksubdir]
          @no_worksubdir = args[:no_worksubdir] || false
          @template = { name: @name }.merge(args[:template])
          @dist_filename = args[:dist_filename]
          @raw_patterns = args[:files]
          logger.debug args
        end

        # Returns Array of Pathname of matched files. The file paths are absolute
        # paths.
        def files
          return @files if @files

          logger.debug "workdir: #{workdir}"

          Dir.chdir(workdir) do
            @files = @raw_patterns.flat_map do |pattern|
              logger.debug "pattern: #{pattern}"
              matched_files = Pathname.glob(pattern)
              return nil if matched_files.empty?

              matched_files.map { |f| Pathname.new f.realpath }
            end.uniq.compact
          end
          logger.debug "files: #{@files}"
          @files
        end

        def dist_filename
          replace(@dist_filename)
        end

        def dist_url
          replace(@dist_url)
        end

        def worksubdir
          replace(@worksubdir)
        end

        def no_worksubdir?
          @no_worksubdir
        end

        def fetch
          return if distfile.exist?

          Rokujo::TMX::FOSS::Downloader::HTTP.new(uri: dist_url, path: distfile, logger: logger).fetch
        end

        def extract
          FileUtils.mkdir_p WRKDIRPREFIX
          FileUtils.mkdir_p workdir
          dest_dir = no_worksubdir? ? workdir : WRKDIRPREFIX
          case ext
          when ".zip"
            Rokujo::TMX::FOSS::Extractor::ZIP.new(file: distfile, dest_dir: dest_dir).extract
          when ".tar.gz", ".tgz", ".tar.xz", ".txz"
            Rokujo::TMX::FOSS::Extractor::Tar.new(file: distfile, dest_dir: dest_dir).extract
          else
            raise "Unknown ext: `#{ext}`"
          end
        end

        # the root directory of the extracted files
        def workdir
          WRKDIRPREFIX / worksubdir
        end

        def workdir_relative
          workdir.relative_path_from(Dir.pwd)
        end

        # the file name to extract
        def distfile
          DISTDIRPREFIX / dist_filename
        end

        def create_tmx
          FileUtils.mkdir_p STAGEDIR

          files.each do |file|
            convert_to_tmx(file)
          end
        end

        def clean
          FileUtils.rm_rf(workdir)
        end

        def logger
          return @logger if @logger

          @logger = Rokujo::TMX::FOSS::Logger.new
        end

        private

        def convert_to_tmx(file)
          raise "file is not readable: #{file}" unless file.readable?

          tmx_file = "#{file}.tmx"
          stage_dir = STAGEDIR / worksubdir / file.relative_path_from(workdir).dirname
          logger.info "Creating stage_dir: #{stage_dir}"
          FileUtils.mkdir_p(stage_dir)

          Dir.chdir(workdir) do
            logger.debug "workdir: #{workdir}"
            logger.debug "tikal -2tmx #{file.to_s.shellescape} -sl EN -tl JA"
            `tikal -2tmx #{file.to_s.shellescape} -sl EN -tl JA`
            logger.info "Moving #{tmx_file} to #{stage_dir}"
            FileUtils.mv tmx_file, stage_dir
          end
        rescue StandardError => e
          logger.error e
          logger.error "skipping #{file.realpath}"
        end

        def file_id(file)
          "#{name}-#{file.relative_path_from(workdir)}"
        end

        def tmx_filename(file)
          file / ".tmx"
        end

        def ext
          known_extentions = %w[
            .tar.gz
            .tar.xz
            .txz
            .tgz
            .zip
          ]
          known_extentions.each do |ext|
            return ext if dist_filename.end_with?(ext)
          end

          raise "dist_filename `#{dist_filename}` has unsupported extention. " \
                "Supported extentions are: " \
                "#{known_extentions}"
        end

        # replace placeholders in a string with templates
        def replace(string)
          return string unless string

          template.each do |key, value|
            string.gsub!(/%%#{key}%%/, value)
          end
          string
        end
      end
    end
  end
end
