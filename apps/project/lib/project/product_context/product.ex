defmodule Project.ProductContext.Product do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query


  schema "products" do
    field :color, :string
    field :size, :string
    field :description, :string
    field :price, :decimal
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :size, :color, :price])
    |> validate_required([:title, :description, :size, :color, :price])
    |> unique_constraint(:id, name: :unique_products_index, message:
    "ID already in use.")
  end

  def search(query, search_term) do
    wildcard_search = "%#{search_term}%"

    from product in query,
    where: like(product.title, ^wildcard_search),
    or_where: like(product.size, ^wildcard_search),
    or_where: like(product.color, ^wildcard_search)
  end

  def filter(query, min, max) do
    wildcard_min = String.to_float("#{min}.0")
    wildcard_max = String.to_float("#{max}.0")

    from product in query,
    where: product.price >= ^wildcard_min and product.price <= ^wildcard_max
  end

end
