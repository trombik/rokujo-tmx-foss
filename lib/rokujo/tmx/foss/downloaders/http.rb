require "httpx"
require "tempfile"
require "fileutils"
require "rokujo/tmx/foss/downloaders/base"

module Rokujo
  module TMX
    module FOSS
      module Downloader
        class HTTP < Rokujo::TMX::FOSS::Downloader::Base
          def fetch
            return if fetched?

            Tempfile.create do |file|
              fetch_stream(file)
              FileUtils.cp file, path
            end
          end

          private

          def fetch_stream(file)
            res = HTTPX.with(debug: false)
                       .plugin(:follow_redirects).get(uri)
            res.raise_for_status
            res.body.copy_to(file)
          rescue StandardError => e
            puts "failed to fetch URI: #{uri} at #{path}"
            raise e
          end
        end
      end
    end
  end
end
