# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    class DemFile
      extend T::Sig

      sig { returns(File) }
      attr_reader :original_file

      sig { returns(String) }
      attr_reader :dem_type

      sig { returns(String) }
      attr_reader :output_format

      sig { returns(T.nilable(CSV)) }
      attr_reader :csv_file

      sig { params(original_file: File, dem_type: String, output_format: String).void }
      def initialize(original_file:, dem_type:, output_format:)
        @original_file = original_file
        @dem_type = dem_type
        @output_format = output_format
        @csv_file = T.let(nil, T.nilable(CSV))
      end

      sig { returns(CSV) }
      def build_csv
        @csv_file ||= T.let(Apis::OpenTopo::Converters::TifToCsvSimpleConverter.call(original_file), T.nilable(CSV))
        @csv_file
      end
    end
  end
end
