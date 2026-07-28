# typed: strict

module OpenTopo
  class AddHeightToVillage
    extend T::Sig

    sig { returns(Village) }
    attr_reader :village

    sig { params(village: Village).void }
    def initialize(village)
      @village = village
    end

    sig { returns(T.nilable(Village)) }
    def call
      return village if village.height_map?

      dem_file = fetch_dem_file_for_village(cardinal_directions_coords(village))
      csv = dem_file.build_csv

      village.update!(height_map: File.open(csv.path))
      File.delete(csv.path) if File.exist?(csv.path)
      village
    rescue Apis::OpenTopo::Errors::ResponseError => _error
      nil
    end

    private

    sig { params(village: Village).returns(Geo::CardinalDirectionsCoords::CardinalDirections) }
    def cardinal_directions_coords(village)
      bbox = village.geom.envelope
      bbox = Geo::UnprojectGeom.call(bbox)
      Geo::CardinalDirectionsCoords.call(bbox)
    end

    sig { params(coords: Geo::CardinalDirectionsCoords::CardinalDirections).returns(Apis::OpenTopo::DemFile) }
    def fetch_dem_file_for_village(coords)
      client = Apis::OpenTopo::Client.new
      client.globaldem(south: coords.south, north: coords.north, west: coords.west, east: coords.east)
    end
  end
end
