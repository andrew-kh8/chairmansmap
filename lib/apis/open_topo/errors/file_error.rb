# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Errors
      class FileError < StandardError
        extend T::Sig

        sig { override.params(message: String, file_path: String).void }
        def initialize(message, file_path:)
          super(message)
          @file_path = file_path
        end

        sig { returns(T.nilable(File)) }
        def file
          File.open(@file_path)
        rescue Errno::ENOENT
          nil
        end
      end
    end
  end
end
