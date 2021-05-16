defmodule ProjectWeb.Plugs.AuthorizationPlug do
  import Plug.Conn
  import Guardian.Plug
  alias Project.UserContext.User
  alias Phoenix.Controller

  def init(options), do: options

  def call(%{private: %{guardian_default_resource: %User{} = u}} = conn, roles) do
    conn
    |> grant_access(u.role in roles)
    current_user = current_resource(conn)
    assign(conn, :current_user, current_user)
  end

  def grant_access(conn, true), do: conn

  def grant_access(conn, false) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: "/")
    |> halt
  end
end
