defmodule Project.OrderContext.Order do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Project.UserContext.User
  alias Project.ProductContext.Product
  alias Project.UserContext.User


  schema "orders" do
    field :total_price, :decimal
    belongs_to :user, User
    many_to_many :products, Product, join_through: "orders_products"

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total_price])
    |> validate_required([:total_price])
    |> cast_assoc(:products)
    |> cast_assoc(:user)
    |> unique_constraint(:id, name: :unique_orders_index, message:
    "ID already in use.")
  end

  def search(query, search_term) do
    wildcard_search = search_term

    from order in query,
    where: order.user_id == ^wildcard_search
  end
end
