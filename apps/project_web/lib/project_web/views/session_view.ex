defmodule ProjectWeb.SessionView do
  use ProjectWeb, :view

  def current_user(conn), do: Guardian.Plug.current_resource(conn)

end
