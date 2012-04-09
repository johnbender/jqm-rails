module ApplicationHelper
  # NOTE severly pushing the "clever" envelope here
  def differentiate_path(path, *args)
    attempt = request.parameters["attempt"]
    args.unshift(path).push(:attempt => attempt ? attempt.to_i + 1 : 1)
    send(*args)
  end

  def link_button_to(text, href, opts = {})
    link_to(text, href, opts.merge( "data-role" => "button", :class => "ui-left"))
  end
end
