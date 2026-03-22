# typed: false

class VillageCreator
  class << self
    extend T::Sig

    class VillageParams < T::Struct
      const :name, String
      const :cadastral_number, String
    end

    sig { params(village_params: T::Hash[Symbol, T.untyped]).returns(Typed::Result[Village, String]) }
    def call(village_params)
      params = TypeCoerce[VillageParams].new.from(village_params)
      village = build_village(params).on_error { |error| return Typed::Failure.new(error) }.payload

      if village.save
        Typed::Success.new(village)
      else
        Typed::Failure.new(village.errors.full_messages.join(", "))
      end
    end

    private

    sig { params(params: VillageParams).returns(Typed::Result[Village, String]) }
    def build_village(params)
      coords = village_coords(params.cadastral_number)
        .on_error { |error| return Typed::Failure.new(error) }
        .payload

      Typed::Success.new(
        Village.new(
          name: params.name,
          cadastral_number: params.cadastral_number,
          geom: coords
        )
      )
    end

    sig { params(cadastral_number: String).returns(Typed::Result[RGeo::Geos::CAPIMultiPolygonImpl, String]) }
    def village_coords(cadastral_number)
      coords = Geo::GetCadasterQuarter.call(cadastral_number)
        .and_then { |coords| Geo::MultiPolygonCreator.call(coords) }
        .on_error { return Typed::Failure.new("Failed to get coordinates") }
        .payload
        .multi_polygon

      Typed::Success.new(coords)
    end
  end
end
