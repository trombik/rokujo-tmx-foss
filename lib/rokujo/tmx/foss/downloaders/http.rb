require "net/http"
require "tempfile"
require "fileutils"
require "rokujo/tmx/foss/downloaders/base"

module Rokujo
  module TMX
    module FOSS
      module Downloader
        # HTTP downloader using standard Net::HTTP.
        class HTTP < Rokujo::TMX::FOSS::Downloader::Base
          MAX_REDIRECTS = 10

          def fetch
            return if fetched?

            logger.debug "Fetching URI: #{uri}"

            Tempfile.create do |file|
              fetch_stream(uri, file)
              FileUtils.cp file, path
            end
          end

          private

          def debug_enabled?
            logger.level == :debug
          end

          # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
          def fetch_stream(current_uri, file, redirect_count = 0)
            raise StandardError, "Too many redirects (max: #{MAX_REDIRECTS})" if redirect_count > MAX_REDIRECTS

            target_uri = URI(current_uri)
            Net::HTTP.start(target_uri.host, target_uri.port, use_ssl: target_uri.scheme == "https") do |http|
              http.set_debug_output($stderr) if debug_enabled?

              request = Net::HTTP::Get.new(target_uri)

              http.request(request) do |response|
                case response
                when Net::HTTPSuccess
                  response.read_body do |chunk|
                    file.write(chunk)
                  end
                  file.close
                when Net::HTTPRedirection
                  location = response["location"]
                  new_uri = URI.join(target_uri, location)
                  return fetch_stream(new_uri, file, redirect_count + 1)
                else
                  response.value
                end
              end
            end
          rescue StandardError => e
            logger.error "failed to fetch URI: #{uri} at #{path}"
            raise e
          end
          # rubocop:enable Metrics/MethodLength,Metrics/AbcSize
        end
      end
    end
  end
end
