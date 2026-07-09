require "minitar"
require "zlib"
require "xz"

module Rokujo
  module TMX
    module FOSS
      class Extractor
        # Extractor implementation with tar. Suppots gzip and xz
        class Tar < Rokujo::TMX::FOSS::Extractor::Base
          def extract
            check_sanity
            source = if gzipped?
                       Zlib::GzipReader.new(File.open(@file.to_s, "rb"))
                     elsif xzed?
                       XZ::StreamReader.open(@file.to_s)
                     else
                       @file.to_s
                     end
            Minitar.unpack(source, @dest_dir)
          end

          def supported_extentions
            %w[.tar .tar.gz .tgz .tar.xz .txz]
          end

          private

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
