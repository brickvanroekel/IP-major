defmodule Project.ProductContext.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :color, :string
    field :size, :string
    field :description, :string
    field :price, :decimal
    field :title, :string
    field :stock, :integer, default: 1

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :size, :color, :price, :stock])
    |> validate_required([:title, :description, :size, :color, :price, :stock])
    |> unique_constraint(:title, name: :unique_products_index, message:
    "Title already in use.")
  end
end
