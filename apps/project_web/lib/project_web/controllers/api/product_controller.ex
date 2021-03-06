defmodule ProjectWeb.Api.ProductController do
  use ProjectWeb, :controller

  alias Project.ProductContext
  #alias Project.ProductContext.Product


  def index(conn, _params) do
    products = ProductContext.list_api_products()
    render(conn, "index.json", products: products)
  end

  def show(conn, %{"id" => id}) do
    product = ProductContext.get_product!(id)
    render(conn, "show.json", product: product)
  end

end
