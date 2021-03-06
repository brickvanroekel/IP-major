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
    |> Repo.preload(:orders)
    |> Product.changeset(attributes)
    |> Repo.insert()
  end

  def create_product_bulk(file) do
    file
    |> File.stream!()
    |> CSV.decode!
    |> Enum.each(fn(product) -> Product.changeset(%Product{}, %{title: Enum.at(product, 0), description: Enum.at(product, 1), size: Enum.at(product, 2), color: Enum.at(product, 3), price: Enum.at(product, 4)})
    |> Repo.insert() end)
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

  def list_api_products, do: Repo.all(Product)


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
