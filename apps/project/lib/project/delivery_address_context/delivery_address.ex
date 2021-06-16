defmodule Project.DeliveryAddressContext.DeliveryAddress do
  use Ecto.Schema
  import Ecto.Changeset

  schema "delivery_addresses" do
    field :bus, :string
    field :number, :string
    field :postal_code, :string
    field :street, :string
    belongs_to :order, Project.OrderContext.Order
  end

  @doc false
  def changeset(delivery_address, attrs) do
    delivery_address
    |> cast(attrs, [:postal_code, :street, :number, :bus])
    |> validate_required([:postal_code, :street, :number])
    |> cast_assoc(:order)
  end

  #def search(query, street) do
  #  wildcard_street = street
  #
  # from delivery_address in query,
  # where: delivery_address.street == ^wildcard_street
  #end
end
