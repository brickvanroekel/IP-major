defmodule Project.OrderContext do
  alias __MODULE__.Order
  alias Project.Repo

  def change_product(%Order{} = order) do
    order |> Order.changeset(%{})
  end

  def create_order(attributes) do
    %Order{}
    |> Order.changeset(attributes)
    |> Repo.preload(:products)
    |> Repo.insert()
  end

  def list_orders, do: Repo.all(Order)



end
