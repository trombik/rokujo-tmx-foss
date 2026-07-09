require_relative "extractors/zip"
require_relative "extractors/tar"

module Rokujo
  module TMX
    module FOSS
      # loader class to load extractors
      class Extractor
        def self.for(file)
          filename = file.basename.to_s
          if filename.end_with?(".zip")
            Rokujo::TMX::FOSS::Extractor::ZIP
          elsif filename.match?(/\.(tar|tar\.gz|tar\.xz|tgz|txz)\z/)
            Rokujo::TMX::FOSS::Extractor::Tar
          else
            raise ArgumentError
          end
        end
      end
    end
  end
end
