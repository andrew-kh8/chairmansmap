class Api::People::ActivePeopleController < ApplicationController
  api! 'det all active (not discarded) people'
  returns code: 200 do
    param_group :people, Api::People::PeopleController
  end
  def index
    people = Person.kept.order(:surname)
    render json: Panko::ArraySerializer.new(people, each_serializer: PersonSerializer).to_json
  end
end
