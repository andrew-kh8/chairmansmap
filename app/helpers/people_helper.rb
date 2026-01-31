module PeopleHelper
  def table_headers
    [
      {column_name: "ФИО", param_name: "name"},
      {column_name: "Телефон", param_name: nil},
      {column_name: "Адрес", param_name: nil},
      {column_name: "Участник", param_name: "member"},
      {column_name: "Участков", param_name: nil},
      {column_name: "Действия", param_name: nil}
    ]
  end

  def build_params(params_name)
    sort_params = params[:sort]&.end_with?("_desc") ? params_name : params_name + "_desc"
    request.params.merge({sort: sort_params})
  end

  def no_sort?(param_name)
    !params[:sort]&.start_with?(param_name)
  end

  def path_d(params_name)
    if no_sort?(params_name)
      "M4 8h16 M4 16h16"
    elsif params[:sort]&.end_with?("_desc")
      "M19 9l-7 7-7-7"
    else
      "M5 15l7-7 7 7"
    end
  end
end
