require "delegate"
require "dry/logger"

module Rokujo
  module TMX
    module FOSS
      # Wrapper logger class for CLI.
      class Logger < SimpleDelegator
        def initialize(...)
          @logger = Dry::Logger(...)
          super(@logger)
        end
      end
    end
  end
end
