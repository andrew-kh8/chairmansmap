# frozen_string_literal: true

module Api
  module People
    class ArchivePeopleController < ApplicationController
      api! 'get all discarded people'
      returns code: 200 do
        param_group :people, Api::People::PeopleController
      end
      def index
        people = Person.discarded.order(:surname)
        render json: Panko::ArraySerializer.new(people, each_serializer: PersonSerializer).to_json
      end
    end
  end
end
