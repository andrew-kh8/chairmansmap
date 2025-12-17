class PeopleController < ApplicationController
  include Pagy::Method
  include PeopleHelper

  def index
    people = PeopleSearch
      .call(search_params)
      .includes(owners: :plot)

    @pagy, @people = pagy(:offset, people, limit: 10)
  end

  def show
    person = Person.preload(:plots).find(params[:id])
    person_plots = person.plots.preload(:plot_datum)

    render :show, locals: {person: person, person_plots: person_plots}
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    person = Person.find(params[:id])
    person.update!(person_params)

    redirect_to person_path(person)
  end

  private

  def person_params
    params.require(:person).permit(:surname, :first_name, :middle_name, :tel, :address)
  end

  def search_params
    permitted = params.permit(:full_name, :active, :plot_presence, :sort)
    permitted[:active] = ActiveModel::Type::Boolean.new.cast(permitted[:active])
    permitted[:plot_presence] = ActiveModel::Type::Boolean.new.cast(permitted[:plot_presence])
    permitted
  end
end
