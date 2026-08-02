# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Converters
      class StringToTifConverter
        extend T::Sig

        DATE_TIME_FORMAT = "%F-%H-%M-%S"
        FILE_WRITE_MODE = "wb"

        sig { params(string: String, filename: T.nilable(String)).returns(File) }
        def self.call(string, filename: nil)
          filename ||= build_filename
          File.write(filename, string, mode: FILE_WRITE_MODE)
          File.open(filename)
        end

        sig { returns(String) }
        def self.build_filename
          "#{DateTime.now.strftime(DATE_TIME_FORMAT)}.tif"
        end

        private_class_method :build_filename
      end
    end
  end
end
