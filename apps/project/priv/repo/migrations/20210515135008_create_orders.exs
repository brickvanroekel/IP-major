defmodule Project.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :user_id, references(:users)
      add :total_price, :decimal

      timestamps()
    end

    create unique_index(:orders, [:id], name: :unique_orders_index)

  end
end
