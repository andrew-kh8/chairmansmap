# typed: strict

class PeopleController < ApplicationController
  extend T::Sig
  include Pagy::Method
  include PeopleHelper

  sig { void }
  def index
    people = PeopleSearch
      .call(search_params)
      .includes(owners: :plot)

    pagy, people = pagy(:offset, people, limit: 10)

    render :index, locals: {pagy:, people:}
  end

  sig { void }
  def show
    person = Person.preload(:plots).find(params[:id])
    person_plots = person.plots

    render :show, locals: {person: person, person_plots: person_plots}
  end

  sig { void }
  def edit
    person = Person.find(params[:id])

    render :edit, locals: {person:}
  end

  sig { void }
  def update
    person = Person.find(params[:id])
    person.update!(person_params)

    redirect_to person_path(person)
  end

  private

  sig { returns(ActionController::Parameters) }
  def person_params
    params.require(:person).permit(:surname, :first_name, :middle_name, :tel, :address)
  end

  sig { returns(ActionController::Parameters) }
  def search_params
    permitted = params.permit(:full_name, :active, :plot_presence, :sort)
    permitted[:active] = ActiveModel::Type::Boolean.new.cast(permitted[:active])
    permitted[:plot_presence] = ActiveModel::Type::Boolean.new.cast(permitted[:plot_presence])
    permitted
  end
end
