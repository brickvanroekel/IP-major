defmodule Project.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :description, :string
      add :size, :string
      add :color, :string
      add :price, :decimal
      add :stock, :integer
      timestamps()
    end

    create unique_index(:products, [:title], name: :unique_products_index)

  end
end
