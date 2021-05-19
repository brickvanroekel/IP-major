defmodule ProjectWeb.Api.UserController do
  use ProjectWeb, :controller
  alias Project.{UserContext,OrderContext}



  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    orders = OrderContext.list_orders(id)
    render(conn, "show.json", orders: orders)
  end
end
