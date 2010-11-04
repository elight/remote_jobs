module ApplicationHelper

  def link_to_active(name, url, html_options = {})
    html_options[:class] = "active" if current_page?(url)
    link_to(name, url, html_options)
  end
end
