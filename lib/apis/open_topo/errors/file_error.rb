# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Errors
      class FileError < BaseError
        sig { override.params(message: T.untyped, file_path: T.nilable(String)).void }
        def initialize(message = "", file_path: nil)
          super(message)
          @file_path = file_path
        end

        sig { returns(T.nilable(File)) }
        def file
          return nil if @file_path.nil?

          File.open(@file_path)
        rescue Errno::ENOENT
          nil
        end
      end
    end
  end
end
