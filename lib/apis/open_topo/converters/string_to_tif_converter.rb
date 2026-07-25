# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Converters
      class StringToTifConverter
        extend T::Sig

        DATE_TIME_FORMAT = "%F-%H-%M-%S"

        sig { params(string: String).returns(Tempfile) }
        def self.call(string)
          file = Tempfile.new([DateTime.now.strftime(DATE_TIME_FORMAT), ".tif"], binmode: true)
          file.write(string)
          file.rewind

          file
        end
      end
    end
  end
end
