module ApplicationHelper
  def sortable_column(title, column)
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }
  end
end
