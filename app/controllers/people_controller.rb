class PeopleController < ApplicationController
  def index
    @people = Person.all.order(:surname).includes(owners: :plot)
  end

  def show
    @person = Person.find(params[:id])
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    Person.find(params[:id]).update!(person_params)
    redirect_to person_path(params[:id])
  end

  private

  def person_params
    params.require(:person).permit(:surname, :first_name, :middle_name, :tel, :address)
  end
end
