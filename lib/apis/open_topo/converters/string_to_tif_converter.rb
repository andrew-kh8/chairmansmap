# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Converters
      class StringToTifConverter
        extend T::Sig

        DATE_TIME_FORMAT = "%F-%H-%M-%S"
        FILE_WRITE_MODE = "wb"

        sig { params(string: String).returns(File) }
        def self.call(string)
          File.write(filename, string, mode: FILE_WRITE_MODE)
          File.open(filename)
        end

        private_class_method :filename

        sig { returns(String) }
        def self.filename
          "#{DateTime.now.strftime(DATE_TIME_FORMAT)}.tif"
        end
      end
    end
  end
end
