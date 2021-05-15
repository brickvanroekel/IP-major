defmodule ProjectWeb.CartController do
  use ProjectWeb, :controller

  import Guardian.Plug
  alias Project.ProductContext.Product
  alias Project.{ProductContext, Carts}
  alias Project.Workers.CartAgent



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

  #def show(conn, _params) do
    #render(conn, "show.html", order: conn.assigns.current_order)
  #end
end
