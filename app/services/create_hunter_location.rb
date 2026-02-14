# typed: strict

class CreateHunterLocation
  extend T::Sig

  sig { params(params: T.untyped).returns(HunterLocation) }
  def self.call(params)
    HunterLocation.create!(parsed_params(params))
  end

  private_class_method

  sig { params(raw_params: T.untyped).returns(T::Hash[Symbol, T.untyped]) }
  def self.parsed_params(raw_params)
    coords = raw_params[:location].split.map(&:to_f)
    lat = coords.first.to_f
    lng = coords.last.to_f

    location = Geo::TransformPointSrid.call(lng, lat)

    raw_params[:location] = location
    raw_params
  end
end
