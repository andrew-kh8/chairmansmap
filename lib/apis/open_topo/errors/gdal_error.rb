# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Errors
      class GdalError < StandardError
        extend T::Sig

        sig { override.params(message: String).void }
        def initialize(message)
          super
        end
      end
    end
  end
end
