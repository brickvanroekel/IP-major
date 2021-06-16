defmodule Project.Repo.Migrations.CreateDeliveryAddresses do
  use Ecto.Migration

  def change do
    create table(:delivery_addresses) do
      add :postal_code, :string
      add :street, :string
      add :number, :string
      add :bus, :string
      add :order_id, references(:orders, on_delete: :delete_all)

    end

    create index(:delivery_addresses, [:order_id, :postal_code, :street, :number])

  end

end
