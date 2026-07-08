require "zip"

module Rokujo
  module TMX
    module FOSS
      module Extractor
        class ZIP
          MAX_SIZE_BYTE = 1024 * 1024 * 1024

          def initialize(file:, dest_dir:, **args)
            @file = file
            @dest_dir = dest_dir
            @args = args
            check_sanity
          end

          def extract
            Zip::File.open(@file) do |zip_file|
              zip_file.each do |entry|
                raise "File `#{entry.name}` is too large (#{entry.size} > #{MAX_SIZE_BYTE})" if file_too_large?(entry)

                entry.extract(destination_directory: @dest_dir)
              end
            end
          end

          private

          def file_too_large?(entry)
            entry.size > MAX_SIZE_BYTE
          end

          def check_sanity
            raise "#{@dest_dir} does not exist" unless @dest_dir.exist? && @dest_dir.directory?
          end
        end
      end
    end
  end
end
