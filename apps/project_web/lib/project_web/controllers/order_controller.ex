defmodule ProjectWeb.OrderController do
    use ProjectWeb, :controller

    alias Project.{Carts, OrderContext,DeliveryAddressContext}
    #alias Project.Workers.CartAgent
    alias Project.{Mailer, Email}
    alias Project.Repo


    def overview(conn, _params) do
        current_user = Guardian.Plug.current_resource(conn)
        orders = current_user.id
        |> OrderContext.list_orders()
        render(conn, "overview.html", orders: orders)
    end

    @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
    def show(conn, %{"order_id" => id}) do
        order = id
        |> OrderContext.get_order!()
        |> Repo.preload(:products)
        |> Repo.preload(:delivery_address)
        render(conn, "show.html", order: order)
      end

    def total_price(products) do
      Enum.reduce(products, fn product, acc ->
        %{price: Decimal.add(product.price,acc.price)}
      end)
      |> Map.get(:price)
    end

    def create(conn, %{"delivery_address_params" => delivery_address_params}) do
      current_user = Guardian.Plug.current_resource(conn)
      products = Carts.get(current_user.email)
      delivery_address = DeliveryAddressContext.get_delivery_address!(delivery_address_params)
      order_changeset = Ecto.build_assoc(current_user, :orders, products: products, total_price: total_price(products), delivery_address: delivery_address)
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
