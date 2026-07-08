require "minitar"
require "zlib"
require "xz"

module Rokujo
  module TMX
    module FOSS
      module Extractor
        class Tar
          def initialize(file:, dest_dir:, **args)
            @file = file
            @dest_dir = dest_dir
            @args = args
          end

          def extract
            source = if gzipped?
                       Zlib::GzipReader.new(File.open(@file.to_s, "rb"))
                     elsif xzed?
                       XZ::StreamReader.open(@file.to_s)
                     else
                       @file.to_s
                     end
            Minitar.unpack(source, @dest_dir)
          end

          def gzipped?
            @file.to_s.end_with?(".tar.gz") || @file.to_s.end_with?(".tgz")
          end

          def xzed?
            @file.to_s.end_with?(".tar.xz") || @file.to_s.end_with?(".txz")
          end
        end
      end
    end
  end
end
