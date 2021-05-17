defmodule Project.OrderContext do
  alias __MODULE__.Order
  alias Project.Repo

  def change_product(%Order{} = order) do
    order |> Order.changeset(%{})
  end

  def create_order(attributes, products, user) do
    %Order{}
    |> Repo.preload(:products)
    |> Repo.preload(:user)
    |> Order.changeset(attributes)
    |> Repo.insert()
  end

  def list_orders() do
    Repo.all(Order)
  end
end
