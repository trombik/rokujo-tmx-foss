require "dry/cli"

module Rokujo
  module TMX
    module FOSS
      module CLI
        module Commands
          # Command to extract distfiles
          class Extract < Rokujo::TMX::FOSS::CLI::Commands::Base
            desc "Extract distfiles"
            argument :config, required: true, desc: "Path to YAML configuration file"

            def call(*)
              logger.info "Extracted"
            end

            def depends
              [
                Rokujo::TMX::FOSS::CLI::Commands::Fetch
              ]
            end
          end
        end
      end
    end
  end
end
