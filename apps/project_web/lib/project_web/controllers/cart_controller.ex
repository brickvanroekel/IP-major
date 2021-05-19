defmodule ProjectWeb.CartController do
  use ProjectWeb, :controller


  alias Project.{ProductContext, Carts}
  alias Project.Workers.CartAgent
  #alias Project.{Mailer, Email}



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
    |> redirect(to: Routes.cart_path(conn, :show))
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

end
