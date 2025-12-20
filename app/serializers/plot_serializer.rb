class PlotSerializer < Panko::Serializer
  attributes :id, :number, :area, :perimeter, :cadastral_number, :sale_status, :description, :owner_type

  has_one :person, serializer: PersonSerializer
end
