class PersonSerializer < Panko::Serializer
  attributes :id, :first_name, :middle_name, :surname, :tel, :address, :member_from, :plot_count

  has_many :owners

  def member_from
    object.member_from.strftime("%d.%m.%Y")
  end

  def plot_count
    object.owners.map(&:plot).count
  end
end
