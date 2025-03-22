# frozen_string_literal: true

class PeopleController < ApplicationController
  def index
    @people = Person.all.order(:surname).includes(owners: :plot)
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    Person.find(params[:id]).update!(person_params)
    redirect_to person_index_path
  end

  private

  def person_params
    params.require(:person).permit(:surname, :first_name, :middle_name, :tel, :address)
  end
end
