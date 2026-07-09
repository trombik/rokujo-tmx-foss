require "dry/cli"
require_relative "../../version"

module Rokujo
  module TMX
    module FOSS
      module CLI
        module Commands
          # Command to print version.
          class Version < Dry::CLI::Command
            desc "Print version"

            def call(*)
              puts Rokujo::TMX::FOSS::VERSION
            end
          end
        end
      end
    end
  end
end
