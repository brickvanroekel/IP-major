defmodule ProjectWeb.ProductApiView do
  use ProjectWeb, :view

  def render("overview.json", %{products: products}) do
    %{data: render_many(products, ApiProductView, "product.json")} # Create a json with key = data & value = an array of products. The render_many is used to call render on every attribute in the (products)-list
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ApiProductView, "product.json")} #Create a json with key = data & value = a dictionary of a single product.
  end

  def render("product.json", %{product: product}) do # render(show.json, product) & render(overview.json, products) call this function to know how to exactly create a json of a product attribute.
    %{id: product.id, title: product.title}
  end
end
