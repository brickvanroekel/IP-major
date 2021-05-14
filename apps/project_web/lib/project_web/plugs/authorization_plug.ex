defmodule ProjectWeb.Plugs.AuthorizationPlug do
  import Plug.Conn
  import Guardian.Plug
  alias Project.UserContext.User
  alias Phoenix.Controller

  def init(options), do: options

  def call(%{private: %{guardian_default_resource: %User{} = u}} = conn, roles) do
    assign(conn, :current_user, u)
    conn
    |> grant_access(u.role in roles)

  end

  def grant_access(conn, true), do: conn

  def grant_access(conn, false) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: "/")
    |> halt
  end
end
