module ApplicationHelper
  def link_button_to(text, href, opts = {})
    link_to(text, href, opts.merge( "data-role" => "button", :class => "ui-left"))
  end
end
