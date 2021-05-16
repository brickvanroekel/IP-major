defmodule ProjectWeb.ApiKeyController do
  use ProjectWeb, :controller
  alias Project.UserContext

  #plug ProjectWeb.Plugs.CheckAuth


  def create(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    case UserContext.generate_user_api_key(user) do
      {:ok, _api_key} ->
        conn
        |> put_flash(:info, "Your API key was generated")
        |> redirect(to: Routes.user_path(conn, :show, user))
      {:error, _} ->
        conn
        |> put_flash(:error, "There was an problem generating the API key")
        |> redirect(to: Routes.user_path(conn, :show, user))
    end
  end

end
