class PeopleController < ApplicationController
  def index
    @people = Person.all.order(:surname).includes(owners: :plot)
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
end
