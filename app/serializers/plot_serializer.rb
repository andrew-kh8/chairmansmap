# frozen_string_literal: true

class PlotSerializer < Panko::Serializer
  attributes :number, :area, :perimetr

  has_one :plot_datum, serializer: PlotDatumSerializer
  has_one :person, serializer: PersonSerializer
end
