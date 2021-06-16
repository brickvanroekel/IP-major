defmodule Project.OrderContext do
  alias __MODULE__.Order
  alias Project.Repo

  def change_product(%Order{} = order) do
    order |> Order.changeset(%{})
  end

  def create_order(attributes, _products, _user) do
    %Order{}
    |> Repo.preload(:products)
    |> Repo.preload(:user)
    |> Repo.preload(:deliver_address)
    |> Order.changeset(attributes)
    |> Repo.insert()
  end

  def list_orders() do
    Repo.all(Order)
  end

  def list_orders(params) do
    #search_term = get_in(params, ["query"])
    Order
    |> Order.search(params)
    |> Repo.all()
  end

  def get_order!(id), do: Repo.get!(Order, id)

end
