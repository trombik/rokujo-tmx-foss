require "delegate"
require "tty-logger"

module Rokujo
  module TMX
    module FOSS
      # Wrapper logger class for CLI.
      class Logger < SimpleDelegator
        def initialize(*)
          @logger = TTY::Logger.new(*) do |config|
            config.level = :debug
          end
          super(@logger)
        end
      end
    end
  end
end
