defmodule ProjectWeb.ProductApiController do
  use ProjectWeb, :controller

  alias Project.ProductContext

  def overview(conn) do
    products = ProductContext.list_api_products()
    render(conn, "overview.json", products: products)
  end

  def show(conn, %{"product_id" => id}) do
    product = ProductContext.get_product!(id)
    render(conn, "show.json", product: product)
  end

end
