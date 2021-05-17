defmodule ProjectWeb.Plugs.ApiAuth do
  import Plug.Conn

  alias Project.UserContext

  def init(_arts) do
  end

  def call(conn, _arts) do
    key = conn
      |> get_req_header("webshop-api-key")
      |> parse_key()

    if UserContext.api_key_exists?(key) do
      conn
    else
      conn
        |> send_resp(:unauthorized, "Invalid API key")
        |> halt()
    end
  end

  defp parse_key([]), do: nil
  defp parse_key([key]), do: key
end
