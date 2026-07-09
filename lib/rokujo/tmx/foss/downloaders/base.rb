require "pathname"
require "uri"

module Rokujo
  module TMX
    module FOSS
      module Downloader
        # Base class for Downloader, Subclass should implement fetch.
        class Base
          attr_reader :uri, :path, :logger

          def initialize(uri:, path:, logger:, **args)
            @uri = URI(uri)
            @path = Pathname.new(path)
            @logger = logger
            @args = args
          end

          def fetch
            raise NotImplementedError
          end

          def fetched?
            @path.exist?
          end
        end
      end
    end
  end
end
