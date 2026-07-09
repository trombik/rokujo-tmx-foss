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
                project.fetch
                project.extract
                project.create_tmx
              end
              logger.info "Generated TMX files."
            end
          end
        end
      end
    end
  end
end
