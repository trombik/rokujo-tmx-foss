require "pathname"
require "rokujo/tmx/foss/downloaders/http"
require "rokujo/tmx/foss/extractor"
require "rokujo/tmx/foss/logger"
require "shellwords"

module Rokujo
  module TMX
    module FOSS
      # A project
      class Project
        DISTDIRPREFIX = Pathname.pwd / "distfiles"
        WRKDIRPREFIX = Pathname.pwd / "work"
        STAGEDIRPREFIX = Pathname.pwd / "stage"

        attr_reader :logger

        def initialize(**args)
          @args = args
          @logger = @args[:logger] || Rokujo::TMX::FOSS::Logger.new(:app)
          @logger.info args
        end

        def name
          @args[:name]
        end

        def dist_url
          replace(@args[:dist_url])
        end

        def worksubdir
          replace(@args[:worksubdir])
        end

        def no_worksubdir
          @args[:no_worksubdir]
        end

        def template
          { name: @args[:name] }.merge(@args[:template])
        end

        def dist_filename
          Pathname.new replace(@args[:dist_filename])
        end

        def raw_patterns
          @args[:files]
        end

        def stagedir
          @args[:stagedir] || STAGEDIRPREFIX
        end

        # Returns Array of Pathname of matched files. The file paths are absolute
        # paths.
        def files
          return @files if @files

          @files = []

          Dir.chdir(workdir) do
            @files = raw_patterns.flat_map do |pattern|
              matched_files = Pathname.glob(pattern)
              matched_files.empty? ? nil : matched_files.map { |f| Pathname.new f.realpath }
            end.uniq.compact
          end
          @files
        end

        def no_worksubdir?
          @args[:no_worksubdir]
        end

        def fetched?
          distfile.exist?
        end

        def fetch
          return if fetched?
          FileUtils.mkdir_p distdir

          Rokujo::TMX::FOSS::Downloader::HTTP.new(uri: dist_url, path: distfile, logger: logger).fetch
        end

        def extract
          FileUtils.mkdir_p workdir
          dest_dir = no_worksubdir? ? workdir : WRKDIRPREFIX
          extractor = Rokujo::TMX::FOSS::Extractor.for(dist_filename).new(
            file: distfile,
            dest_dir: dest_dir,
            logger: logger
          )
          extractor.extract
        end

        # the root directory of the extracted files
        def workdir
          path = @args[:workdir] ? @args[:workdir] / worksubdir : WRKDIRPREFIX / worksubdir
          Pathname.new(path).expand_path
        end

        def workdir_relative
          workdir.relative_path_from(Dir.pwd)
        end

        # the file name to extract
        def distfile
          Pathname.new(distdir / dist_filename)
        end

        def distdir
          Pathname.new(@args[:distdir] || DISTDIRPREFIX)
        end

        def create_tmx
          FileUtils.mkdir_p stagedir

          files.each do |file|
            convert_to_tmx(file)
          end
        end

        def clean
          FileUtils.rm_rf(workdir)
        end

        private

        def convert_to_tmx(file)
          raise "file is not readable: #{file}" unless file.readable?

          dest = stagedir / worksubdir / file.relative_path_from(workdir).dirname

          logger.info "Creating dest: #{dest}"
          FileUtils.mkdir_p(dest)
          logger.debug "workdir: #{workdir}"
          run_converter(file, dest.expand_path)
        end

        def run_converter(file, dest)
          raise "dest, `#{dest}`, must be absolute path" unless dest.absolute?

          Dir.chdir(workdir) do
            logger.debug "tikal -2tmx #{file.to_s.shellescape} -sl EN -tl JA"
            `tikal -2tmx #{file.to_s.shellescape} -sl EN -tl JA`
            tmx_file = "#{file}.tmx"
            logger.info "Moving #{tmx_file} to #{dest}"
            FileUtils.mv tmx_file, dest
          end
        end

        def file_id(file)
          "#{name}-#{file.relative_path_from(workdir)}"
        end

        # replace placeholders in a string with templates
        def replace(string_or_pathname)
          string = string_or_pathname.to_s

          template.each do |key, value|
            string.gsub!(/%%#{key}%%/, value)
          end
          string
        end
      end
    end
  end
end
