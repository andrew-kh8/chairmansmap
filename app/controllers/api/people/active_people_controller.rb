class Api::People::ActivePeopleController < ApplicationController
  def index
    people = Person.kept.order(:surname)
    render json: Panko::ArraySerializer.new(people, each_serializer: PersonSerializer).to_json
  end
end
