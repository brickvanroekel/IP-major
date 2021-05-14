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

  @doc "Returns all products equal to the search term"
  def list_products(params) do
    search_term = get_in(params, ["query"])

    Product
    |> Product.search(search_term)
    |> Repo.all()
  end

  @doc "Return products between a min and max price"
  def filter_products(params) do
    min = get_in(params, ["min"])
    max = get_in(params, ["max"])

    Product
    |> Product.filter(min,max)
    |> Repo.all()
  end

  @doc "Update an existing product with external attributes"
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc "Delete a product"
  def delete_product(%Product{} = product), do: Repo.delete(product)

  def get_product(id), do: Repo.get(Product, id)
end
