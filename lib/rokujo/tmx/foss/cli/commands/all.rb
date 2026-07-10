require "dry/cli"

module Rokujo
  module TMX
    module FOSS
      module CLI
        module Commands
          # Command to fetch distfiles
          class All < Rokujo::TMX::FOSS::CLI::Commands::Base
            desc "Fetch distfiles"

            def call(**)
              super
              Rokujo::TMX::FOSS::CLI::Commands::Fetch.new.call(**)
              Rokujo::TMX::FOSS::CLI::Commands::Extract.new.call(**)
              Rokujo::TMX::FOSS::CLI::Commands::TMX.new.call(**)
              Rokujo::TMX::FOSS::CLI::Commands::Clean.new.call(**)
            end
          end
        end
      end
    end
  end
end
