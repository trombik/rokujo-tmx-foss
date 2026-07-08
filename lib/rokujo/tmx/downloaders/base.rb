require "pathname"
require "uri"

module Rokujo
  module TMX
    module Downloader
      class Base
        attr_reader :uri, :path

        def initialize(uri:, path:, **args)
          @uri = URI(uri)
          @path = Pathname.new(path)
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
