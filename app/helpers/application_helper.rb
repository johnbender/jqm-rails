module ApplicationHelper
  # NOTE severly pushing the "clever" envelope here
  def differentiate_path(path, *args)
    attempt = (request.parameters["attempt"] || 0) + 1
    args.unshift(path).push(:attempt => attempt)
    send(*args)
  end

  def link_button_to(text, href, opts = {})
    link_to(text, href, opts.merge( "data-role" => "button", :class => "ui-left"))
  end
end
