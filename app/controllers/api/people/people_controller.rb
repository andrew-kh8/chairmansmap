class Api::People::PeopleController < ApplicationController
  resource_description do
    short 'Person'

    deprecated false
    description 'Just people'
  end

  def_param_group :people do
    property :people, Array, 'array of people' do
      property :id, Integer
      property :first_name, String
      property :middle_name, String
      property :surname, String
      property :tel, String
      property :address, String
      property :member_from, String
      property :plot_count, Integer
      property :owners, Array do
        property :id, Integer
        property :active_from, String
        property :active_to, String
      end
    end
  end

  api! 'get all people (discarded and not)'
  returns code: 200 do
    param_group :people
  end
  def index
    people = Person.all.order(:surname)
    render json: Panko::ArraySerializer.new(people, each_serializer: PersonSerializer).to_json
  end
end
