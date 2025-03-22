# frozen_string_literal: true

class OwnerSerializer < Panko::Serializer
  attributes :id, :active_from, :active_to
end
