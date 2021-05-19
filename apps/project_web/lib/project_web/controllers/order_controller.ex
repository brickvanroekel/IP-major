defmodule ProjectWeb.OrderController do
    use ProjectWeb, :controller

    alias Project.{Carts, OrderContext}
    #alias Project.Workers.CartAgent
    alias Project.{Mailer, Email}
    alias Project.Repo


    def overview(conn, _params) do
        current_user = Guardian.Plug.current_resource(conn)
        orders = OrderContext.list_orders(current_user.id)
        render(conn, "overview.html", orders: orders)
    end

    def show(conn, %{"order_id" => id}) do
        order = id
        |> OrderContext.get_order!()
        |> Repo.preload(:products)

        render(conn, "show.html", order: order)
      end

    def total_price(products) do
      Enum.reduce(products, fn product, acc ->
        %{price: Decimal.add(product.price,acc.price)}
      end)
      |> Map.get(:price)
    end

    def create(conn, _params) do
      current_user = Guardian.Plug.current_resource(conn)
      products = Carts.get(current_user.email)

      order_changeset = Ecto.build_assoc(current_user, :orders, products: products, total_price: total_price(products))
      Repo.insert(order_changeset)

      Carts.empty(current_user.email)
      send_order_notification(products, current_user)

      conn
      |> put_flash(:info, "Order successfull!")
      render(conn, "thanks.html")
    end

    defp send_order_notification(cart, current_user) do
      Email.order_email(cart, current_user) |> Mailer.deliver_later()
    end
end
