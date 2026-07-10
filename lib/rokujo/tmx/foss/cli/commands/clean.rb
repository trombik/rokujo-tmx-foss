require "dry/cli"

module Rokujo
  module TMX
    module FOSS
      module CLI
        module Commands
          # Command to generate TMX files
          class Clean < Rokujo::TMX::FOSS::CLI::Commands::Base
            desc "Clean workdir"

            def call(config:, **options)
              super
              projects.each do |project|
                logger.info ">>> Cleaning #{project.name}"
                project.clean
              end
            end
          end
        end
      end
    end
  end
end
