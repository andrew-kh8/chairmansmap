class PlotSerializer < Panko::Serializer
  attributes :id, :number, :area, :perimeter

  has_one :plot_datum, serializer: PlotDatumSerializer
  has_one :person, serializer: PersonSerializer
end
