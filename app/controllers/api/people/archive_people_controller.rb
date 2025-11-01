class Api::People::ArchivePeopleController < ApplicationController
  def index
    people = Person.discarded.order(:surname)
    render json: Panko::ArraySerializer.new(people, each_serializer: PersonSerializer).to_json
  end
end
