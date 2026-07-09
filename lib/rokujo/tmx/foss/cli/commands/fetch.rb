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
              projects.each do |p|
                logger.info "fetching #{p.name}"
                p.fetch
              end
            end
          end
        end
      end
    end
  end
end
