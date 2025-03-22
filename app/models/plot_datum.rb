# frozen_string_literal: true

class PlotDatum < ApplicationRecord
  KADASTR_NUMBER_FORMAT = /\A\d{1,2}:\d{1,2}:\d{1,7}:\d{1,9}\z/
  belongs_to :plot

  enum :sale_status, { nothing: 'не продается', for_sale: 'продается' }
  enum :owner_type, { personal: 'личная собственность', state: 'государственная собственность' }

  validates :plot_id, presence: true
  validates :kadastr_number, uniqueness: true, format: { with: KADASTR_NUMBER_FORMAT } # check migrations for constraint
end
