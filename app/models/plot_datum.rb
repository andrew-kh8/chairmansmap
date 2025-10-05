class PlotDatum < ApplicationRecord
  belongs_to :plot

  enum :sale_status, {"не продается" => "nothing", "продается" => "for_sale"}
  enum :owner_type, {"личная собственность" => "personal", "государственная собственность" => "state"}

  validates :cadastral_number, uniqueness: true, format: {with: /\A\d{1,2}:\d{1,2}:\d{1,7}:\d{1,9}\z/}
end
