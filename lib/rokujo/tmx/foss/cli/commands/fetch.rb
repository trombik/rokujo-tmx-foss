require "dry/cli"

module Rokujo
  module TMX
    module FOSS
      module CLI
        module Commands
          # Command to fetch distfiles
          class Fetch < Rokujo::TMX::FOSS::CLI::Commands::Base
            desc "Fetch distfiles"

            def call(config:, **options)
              super
              projects.each do |project|
                logger.info ">>> Fetching #{project.name}"
                project.fetch
              end
            end
          end
        end
      end
    end
  end
end
