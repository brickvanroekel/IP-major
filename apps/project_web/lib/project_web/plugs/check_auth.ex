defmodule ProjectWeb.Plugs.CheckAuth do
  import Plug.Conn
  import Phoenix.Controller
  alias ProjectWeb.Router.Helpers, as: Routes

  def init(_args) do
  end

  def call(conn, _args) do
  current_user = Guardian.Plug.current_resource(conn)
  params_user_id = conn.params["user_id"] |> String.to_integer()

  if current_user && params_user_id == current_user.id do
    conn
  else
    conn
    |> put_flash(:error, "Unable to access that page")
    |> redirect(to: Routes.user_path(conn, :overview))
    |> halt()
  end

  end
end
