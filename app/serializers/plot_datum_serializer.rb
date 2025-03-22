# frozen_string_literal: true

class PlotDatumSerializer < Panko::Serializer
  attributes :kadastr_number, :sale_status, :description, :owner_type
end
