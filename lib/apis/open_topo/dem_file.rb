# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    class DemFile
      extend T::Sig

      attr_reader :original_file, :dem_type, :output_format

      def initialize(original_file:, dem_type:, output_format:)
        @original_file = original_file
        @dem_type = dem_type
        @output_format = output_format
      end

      def to_csv_file
        Apis::OpenTopo::Converters::TifToCsvConverter.call(@original_file)
      end

      def save_tif(path)
        FileUtils.cp(@original_file.path, path)
        @original_file = File.new(path)
      end
    end
  end
end
