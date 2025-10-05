class CreateHunterLocation
  def call(params)
    HunterLocation.create!(parsed_params(params))
  end

  private

  def parsed_params(raw_params)
    coords = raw_params[:location].split.map(&:to_f)
    lat = coords.first.to_f
    lng = coords.last.to_f

    location = HunterLocation.build_point_from_srid(lng, lat)

    raw_params[:location] = location
    raw_params
  end
end
