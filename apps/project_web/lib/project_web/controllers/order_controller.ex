defmodule ProjectWeb.OrderController do
    use ProjectWeb, :controller

    alias Project.OrderContext

    def show(conn, _params) do
        #current_user = Guardian.Plug.current_resource(conn)
        orders = OrderContext.list_orders()
        render(conn, "show.html", orders: orders)
    end
end
