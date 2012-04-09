module UsersHelper
  # NOTE severly pushing the "clever" envelope here
  def differentiate_path(path = :users_path, *args)
    attempt = request.parameters["attempt"]
    args.unshift(path).push(:attempt => attempt ? attempt.to_i + 1 : 1)
    send(*args)
  end

  # TODO move into application settings
  def status_icon_map
    { "out" => "delete",
      "in" => "check",
      "vacation" => "forward" }
  end
end
