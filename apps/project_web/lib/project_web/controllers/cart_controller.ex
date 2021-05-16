defmodule ProjectWeb.CartController do
  use ProjectWeb, :controller


  alias Project.{ProductContext, Carts, OrderContext}
  alias Project.Workers.CartAgent
  alias Project.{Mailer, Email}



  def update(conn, %{"id" => id}) do
      current_user = Guardian.Plug.current_resource(conn)
      product = ProductContext.get_product!(id)
      Carts.add(current_user.email, product)

      conn
      |> put_flash(:info, "Product added to your cart")
      |> redirect(to: Routes.product_path(conn, :overview))
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    product = ProductContext.get_product!(id)
    CartAgent.delete_item(current_user.email, product.id)

    conn
    |> put_flash(:info, "Product removed from your cart")
    |> redirect(to: Routes.product_path(conn, :overview))
  end

  def show(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    products = Carts.get(current_user.email)
    case products do
      [] ->
        render(conn, "show.html", products: products)
      products ->
        total_price = total_price(products)
        render(conn, "show.html", products: products, total_price: total_price)
    end
  end

  def total_price(products) do
    Enum.reduce(products, fn product, acc ->
      %{price: Decimal.add(product.price,acc.price)}
    end)
    |> Map.get(:price)
  end

  def order(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    products = Carts.get(current_user.email)
    send_order_notification(products, current_user)
    attrs = %{"total_price" => total_price(products)}
    OrderContext.create_order(attrs)
    Carts.empty(current_user.email)
    render(conn, "thanks.html")
  end

  defp send_order_notification(cart, current_user) do
    Email.order_email(cart, current_user) |> Mailer.deliver_later()
  end
end
