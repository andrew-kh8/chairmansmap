# typed: strict
# frozen_string_literal: true

require "ffi-gdal"

module Apis
  module OpenTopo
    module Converters
      class TifToCsvConverter
        extend T::Sig

        DATE_TIME_FORMAT = "%F-%H-%M-%S"
        AFFINE_TRANSFORM_PARAMS_SIZE = 6
        BAND_NUMBER = 1
        FILENAME_SPLITTER = "."
        FILENAME_EXTENSION = "csv"
        TYPE_MAP = T.let({
          GDT_Byte: [:uint8, :read_array_of_uint8],
          GDT_UInt16: [:uint16, :read_array_of_uint16],
          GDT_Int16: [:int16, :read_array_of_short],
          GDT_UInt32: [:uint32, :read_array_of_uint32],
          GDT_Int32: [:int32, :read_array_of_int],
          GDT_Float32: [:float, :read_array_of_float],
          GDT_Float64: [:double, :read_array_of_double]
        }, T::Hash[Symbol, T::Array[Symbol]])

        sig { params(file: File, csv_path: T.nilable(T.any(String, Pathname))).returns(CSV) }
        def self.call(file, csv_path: nil)
          FFI::GDAL::GDAL.GDALAllRegister

          dataset = FFI::GDAL::GDAL.GDALOpen(file.path, FFI::GDAL::GDAL::Access[:GA_ReadOnly])
          raise Errors::FileError.new("Cannot open or read file", file_path: file.path) if dataset.null?

          width = FFI::GDAL::GDAL.GDALGetRasterXSize(dataset)
          height = FFI::GDAL::GDAL.GDALGetRasterYSize(dataset)

          band = FFI::GDAL::GDAL.GDALGetRasterBand(dataset, BAND_NUMBER)
          raise Errors::GdalError.new("Cannot get raster band #{BAND_NUMBER}") if band.null?

          geo_transform = FFI::MemoryPointer.new(:double, AFFINE_TRANSFORM_PARAMS_SIZE)
          raise Errors::GdalError.new("Cannot get affine transform for raster band #{BAND_NUMBER}") if geo_transform.null?

          FFI::GDAL::GDAL.GDALGetGeoTransform(dataset, geo_transform)
          gt = geo_transform.read_array_of_double(AFFINE_TRANSFORM_PARAMS_SIZE)

          data_type_symbol = FFI::GDAL::GDAL.GDALGetRasterDataType(band)
          data_type = FFI::GDAL::GDAL::DataType[data_type_symbol]

          ptr_type, reader = TYPE_MAP[data_type_symbol]
          if ptr_type.nil? || reader.nil?
            raise Errors::GdalError.new("Cannot get type name and reader for data type #{data_type_symbol}")
          end

          origin_x = gt[0]
          pixel_width = gt[1]
          rot_x = gt[2]
          origin_y = gt[3]
          rot_y = gt[4]
          pixel_height = gt[5]

          csv_filename = csv_path || build_csv_filename(file)

          CSV.open(csv_filename, "w") do |csv|
            csv << ["X", "Y", "Z"]

            height.times do |py|
              buf = FFI::MemoryPointer.new(ptr_type, width)

              FFI::GDAL::GDAL.GDALRasterIO(
                band,
                FFI::GDAL::GDAL::RWFlag[:GF_Read],
                0,
                py,
                width,
                1,
                buf,
                width,
                1,
                data_type,
                0,
                0
              )

              row = buf.send(reader, width)

              row.each_with_index do |z, px|
                x_geo = origin_x + (px + 0.5) * pixel_width + (py + 0.5) * rot_x
                y_geo = origin_y + (px + 0.5) * rot_y + (py + 0.5) * pixel_height

                csv << [x_geo, y_geo, z]
              end
            end
          end

          FFI::GDAL::GDAL.GDALClose(dataset)

          CSV.open(csv_filename, "r", headers: true)
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
        end
      end
    end
  end
end
