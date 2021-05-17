defmodule ProjectWeb.Api.UserController do
  use ProjectWeb, :controller
  alias Project.UserContext

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.json", users: users)
  end

  def orders(conn, %{"user_id" => id}) do
    orders = UserContext.list_orders()
    render(conn, "orders.json", orders: orders)
  end
end
