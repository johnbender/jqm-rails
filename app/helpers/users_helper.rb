module UsersHelper
  def differentiate_path
    attempt = request.parameters["attempt"]
    users_path(:attempt => attempt ? attempt.to_i + 1 : 1)
  end

  def status_icon_map
    { "out" => "delete",
      "in" => "check",
      "vacation" => "forward" }
  end
end
