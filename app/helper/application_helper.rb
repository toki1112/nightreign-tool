module ApplicationHelper
  def page_title(title = nil)
    base_title = "Nightreign Practice"

    if title.present?
      "#{title} | #{base_title}"
    else
      base_title
    end
  end
end
