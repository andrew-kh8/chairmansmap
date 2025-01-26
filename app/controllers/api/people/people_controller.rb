class Api::People::PeopleController < ApplicationController
  def index
    people = Person.all.order(:surname)
    render json: Panko::ArraySerializer.new(people, each_serializer: PersonSerializer).to_json
  end
end
