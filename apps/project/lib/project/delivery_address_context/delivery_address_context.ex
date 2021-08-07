defmodule Project.DeliveryAddressContext do
  alias __MODULE__.DeliveryAddress
  alias Project.Repo

  @doc "Returns a product changeset"
  def change_delivery_address(%DeliveryAddress{} = delivery_address) do
    delivery_address |> DeliveryAddress.changeset(%{})
  end

  @doc "Creates a product based on some external attributes"
  def create_delivery_address(attributes) do
    %DeliveryAddress{}
    |> Repo.preload(:order)
    |> DeliveryAddress.changeset(attributes)
    |> Repo.insert()

  end

  def get_delivery_address!(id), do: Repo.get!(DeliveryAddress, id)

  #def get_address(params) do
  #  #search_term = get_in(params, ["query"])
  #  DeliveryAddress
  #  |> DeliveryAddress.search(search_term)
  #  |> Repo.all()
  #end
end
