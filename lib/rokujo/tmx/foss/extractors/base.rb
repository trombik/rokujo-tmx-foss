module Rokujo
  module TMX
    module FOSS
      class Extractor
        # A base class for Extractor.
        #
        class Base
          attr_reader :file, :dest_dir, :logger

          def initialize(file:, dest_dir:, logger:, **args)
            @file = file
            @dest_dir = dest_dir
            @logger = logger
            @args = args
          end

          # Method to extract all files of an archive.
          #
          # Mandatory method that subclasses should implement.
          def extract
            raise NotImplementedError, "BUG: Subclass #{self.class} does not implement mandatory method"
          end

          def supported_extentions
            raise NotImplementedError, "BUG: Subclass #{self.class} does not implement mandatory method"
          end

          def supported_file?(ext)
            supported_extentions.include?(ext)
          end

          # Returns the file extention. Supports double-extention.
          def extname
            if include_two_dots? file.to_s
              extname = file.to_s.split(".")[-2..].join(".")
              ".#{extname}"
            else
              file.extname
            end
          end

          # Optional method to raise error
          # rubocop:disable Metrics/AbcSize
          def check_sanity
            raise "#{dest_dir} does not exist" unless dest_dir.exist?
            raise "#{dest_dir} is not a directory" unless dest_dir.directory?
            raise "#{dest_dir} is not writable" unless dest_dir.writable?
            raise ArgumentError, "#{self.class} does not support `#{extname}`." unless supported_file?(extname)
          end
          # rubocop:enable Metrics/AbcSize

          private

          def include_two_dots?(str)
            str.split(".").size > 2
          end
        end
      end
    end
  end
end
