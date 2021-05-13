defmodule Project.ProductContext do
  alias __MODULE__.Product
  alias Project.Repo

  @doc "Returns a product changeset"
  def change_product(%Product{} = product) do
    product |> Product.changeset(%{})
  end

  @doc "Creates a product based on some external attributes"
  def create_product(attributes) do
    %Product{}
    |> Product.changeset(attributes)
    |> Repo.insert()
  end

  @doc "Returns a specific product or raises an error"
  def get_product!(id), do: Repo.get!(Product, id)

  @doc "Returns all products in the system"
  def list_products, do: Repo.all(Product)

  @doc "Update an existing product with external attributes"
  def update_product(%Product{} = product, attrs) do
    product
    |> product.changeset(attrs)
    |> Repo.update()
  end

  @doc "Delete a product"
  def delete_product(%Product{} = product), do: Repo.delete(product)

  def get_product(id), do: Repo.get(Product, id)
end
