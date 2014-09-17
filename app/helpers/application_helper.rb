module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column
    sort_fa_icon = column == sort_column ? fa_icon("sort-#{sort_direction}") : fa_icon("sort")
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to "#{title} #{sort_fa_icon}".html_safe, params.merge(sort: column, direction: direction)
  end

  def title(page_title = "Title")
    content_for :title, page_title
  end
  def head_keyword(keywords = "Keywords")
    content_for :head_keyword, keywords
  end
  def head_desc(desc = "Desc")
    content_for :head_desc, desc
  end

end
