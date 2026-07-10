require "dry/cli"
require "yaml"

require "rokujo/tmx/foss/project"
require "rokujo/tmx/foss/logger"

module Rokujo
  module TMX
    module FOSS
      module CLI
        # CLI commands
        module Commands
          extend Dry::CLI::Registry

          # Base class for commands.
          class Base < Dry::CLI::Command
            argument :config, required: true, desc: "Path to YAML configuration file"

            option :distdir, required: false, desc: "Path to distdir", default: "distfiles"
            option :workdir, required: false, desc: "Path to workdir", default: "work"
            option :stagedir, required: false, desc: "Path to stagedir", default: "stage"
            option :log_level, required: false, desc: "Log level", default: :info, values: [:debug, :info, :warn]

            # subclass must call super first
            def call(config:, **options)
              @config = config
              @options = options
              logger.debug "config: #{@config}"
              logger.debug "options: #{@options}"
              logger.debug "projects: #{projects}"
            end

            def project_options
              {
                distdir: Pathname.new(@options.fetch(:distdir)),
                workdir: Pathname.new(@options.fetch(:workdir)),
                stagedir: Pathname.new(@options.fetch(:stagedir))
              }
            end

            def logger
              @logger ||= Rokujo::TMX::FOSS::Logger.new(:app, level: @options.fetch(:log_level))
            end

            def projects
              return @projects if @projects

              @projects = []
              YAML.unsafe_load_file("examples/postgresql.yml").each do |project|
                project.transform_keys!(&:to_sym)
                @projects << Rokujo::TMX::FOSS::Project.new(**project, **project_options, logger: logger)
              end
            end
          end
        end
      end
    end
  end
end

require_relative "commands/version"
require_relative "commands/fetch"
require_relative "commands/extract"
require_relative "commands/tmx"
require_relative "commands/clean"
require_relative "commands/all"

Rokujo::TMX::FOSS::CLI::Commands.register "version", Rokujo::TMX::FOSS::CLI::Commands::Version
Rokujo::TMX::FOSS::CLI::Commands.register "fetch", Rokujo::TMX::FOSS::CLI::Commands::Fetch
Rokujo::TMX::FOSS::CLI::Commands.register "extract", Rokujo::TMX::FOSS::CLI::Commands::Extract
Rokujo::TMX::FOSS::CLI::Commands.register "tmx", Rokujo::TMX::FOSS::CLI::Commands::TMX
Rokujo::TMX::FOSS::CLI::Commands.register "clean", Rokujo::TMX::FOSS::CLI::Commands::Clean
Rokujo::TMX::FOSS::CLI::Commands.register "all", Rokujo::TMX::FOSS::CLI::Commands::All
