defmodule ProjectWeb.PageView do
  use ProjectWeb, :view

  def current_user(conn) do
    current_user = Guardian.Plug.current_resource(conn)
    case current_user do
      nil ->
        nil
      current_user ->
        current_user
    end
  end

  def current_role(conn) do
    current_user = current_user(conn)
    case current_user.role do
      "User" ->
        "user"
      "Admin" ->
        "admin"
    end
  end
end
