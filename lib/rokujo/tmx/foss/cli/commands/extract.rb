require "dry/cli"

module Rokujo
  module TMX
    module FOSS
      module CLI
        module Commands
          # Command to extract distfiles
          class Extract < Rokujo::TMX::FOSS::CLI::Commands::Base
            desc "Extract distfiles"

            def call(config:, **options)
              super
              projects.each do |project|
                logger.info ">>> Extracting #{project.name}"
                project.extract
              end
            end
          end
        end
      end
    end
  end
end
