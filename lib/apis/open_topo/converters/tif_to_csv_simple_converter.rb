# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Converters
      class TifToCsvSimpleConverter
        extend T::Sig

        FILENAME_SPLITTER = "."
        FILENAME_EXTENSION = "csv"

        sig { params(file: File, csv_path: T.nilable(T.any(String, Pathname))).returns(CSV) }
        def self.call(file, csv_path: nil)
          csv_filename = csv_path || build_csv_filename(file)
          original_filename = file.path

          _message, error, status = Open3.capture3(gdal_translate_command(original_filename, csv_filename))

          if status.success?
            CSV.open(csv_filename, "r", headers: true)
          else
            raise Errors::ConvertError.new(error.strip)
          end
        end

        class << self
          extend T::Sig

          private

          sig { params(file: File).returns(String) }
          def build_csv_filename(file)
            original_filename = file.path.split(FILENAME_SPLITTER)
            original_filename.pop
            original_filename << FILENAME_EXTENSION
            original_filename.join(FILENAME_SPLITTER)
          end

          sig { params(original_filename: String, csv_filename: T.any(String, Pathname)).returns(String) }
          def gdal_translate_command(original_filename, csv_filename)
            "gdal_translate -of XYZ -co COLUMN_SEPARATOR=, -co ADD_HEADER_LINE=YES #{original_filename} #{csv_filename}"
          end
        end
      end
    end
  end
end
