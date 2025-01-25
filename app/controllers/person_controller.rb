class PersonController < ApplicationController
  def index
    respond_to do |format|
      format.html { @people = Person.all.order(:surname).includes(:owners) }

      format.json do
        @people = Person.send(params[:type]).order(:surname)
        render json: Panko::ArraySerializer.new(@people, each_serializer: PersonSerializer).to_json
      end
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    Person.find(params[:id]).update(person_params)
    redirect_to person_index_path
  end

  private

  def person_params
    params.require(:person).permit(:surname, :first_name, :middle_name, :tel, :address)
  end
end
