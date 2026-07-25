# typed: strict
# frozen_string_literal: true

require "ffi-gdal"
require "csv"

module Apis
  module OpenTopo
    module Converters
      class TifToCsvConverter
        extend T::Sig

        DATE_TIME_FORMAT = "%F-%H-%M-%S"
        AFFINE_TRANSFORM_PARAMS_SIZE = 6
        BAND_NUMBER = 1

        sig { params(file: File).returns(CSV) }
        def self.call(file)
          FFI::GDAL::GDAL.GDALAllRegister

          dataset = FFI::GDAL::GDAL.GDALOpen(file.path, FFI::GDAL::GDAL::Access[:GA_ReadOnly])
          raise "cannot open" if dataset.null?

          width = FFI::GDAL::GDAL.GDALGetRasterXSize(dataset)
          height = FFI::GDAL::GDAL.GDALGetRasterYSize(dataset)

          band = FFI::GDAL::GDAL.GDALGetRasterBand(dataset, BAND_NUMBER)

          geo_transform = FFI::MemoryPointer.new(:double, AFFINE_TRANSFORM_PARAMS_SIZE)
          FFI::GDAL::GDAL.GDALGetGeoTransform(dataset, geo_transform)
          gt = geo_transform.read_array_of_double(AFFINE_TRANSFORM_PARAMS_SIZE)

          origin_x = gt[0]
          pixel_width = gt[1]
          rot_x = gt[2]
          origin_y = gt[3]
          rot_y = gt[4]
          pixel_height = gt[5]

          filename = file.path.split("/").last.split(".").first
          full_filename = "#{filename}.csv"

          CSV.open(full_filename, "w") do |csv|
            csv << ["x", "y", "z"]

            height.times do |py|
              buf = FFI::MemoryPointer.new(:float, width)

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
                FFI::GDAL::GDAL::DataType[:GDT_Float32],
                0,
                0
              )

              row = buf.read_array_of_float(width)

              row.each_with_index do |z, px|
                x_geo = origin_x + px * pixel_width + py * rot_x
                y_geo = origin_y + px * rot_y + py * pixel_height

                csv << [x_geo, y_geo, z]
              end
            end
          end

          FFI::GDAL::GDAL.GDALClose(dataset)

          CSV.open(full_filename, "r")
        end
      end
    end
  end
end
