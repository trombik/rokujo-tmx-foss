require "zip"

require_relative "base"

module Rokujo
  module TMX
    module FOSS
      class Extractor
        # An extractor for zip archives.
        #
        class ZIP < Rokujo::TMX::FOSS::Extractor::Base
          MAX_SIZE_BYTE = 1024 * 1024 * 1024

          attr_reader :max_size

          def initialize(max_size: MAX_SIZE_BYTE, **args)
            @max_size = max_size
            super(**args)
          end

          def extract
            check_sanity
            Zip::File.open(@file.to_s) do |zip_file|
              zip_file.each do |entry|
                raise "File `#{entry.name}` is too large (#{entry.size} > #{max_size})" if entry_too_large?(entry)

                entry.extract(destination_directory: @dest_dir.to_s)
              end
            end
          end

          def supported_extentions
            %w[.zip]
          end

          private

          def entry_too_large?(entry)
            entry.size > max_size
          end
        end
      end
    end
  end
end
