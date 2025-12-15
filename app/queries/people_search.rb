class PeopleSearch
  module Scopes
    def by_full_name(full_name)
      return self if full_name.blank?

      where("concat_ws(' ', surname, first_name, middle_name) ILIKE ?", "%#{full_name}%")
    end

    def by_plot_presence(plot_presence)
      return self if plot_presence.nil?

      if plot_presence
        where.associated(:plots)
      else
        where.missing(:plots)
      end
    end

    def by_active(active)
      return self if active.nil?

      if active
        kept
      else
        discarded
      end
    end
  end

  def self.call(filters)
    Person
      .extending(Scopes)
      .by_full_name(filters[:full_name])
      .by_plot_presence(filters[:plot_presence])
      .by_active(filters[:active])
  end
end
