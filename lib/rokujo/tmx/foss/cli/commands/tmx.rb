require "dry/cli"
require_relative "../commands"

module Rokujo
  module TMX
    module FOSS
      module CLI
        module Commands
          # Command to generate TMX files
          class TMX < Rokujo::TMX::FOSS::CLI::Commands::Base
            desc "Create TMX files from extracted distfiles"

            def call(config:, **options)
              super
              projects.each do |project|
                logger.info ">>> Generating TMX for #{project.name}"
                project.create_tmx
              end
            end
          end
        end
      end
    end
  end
end
