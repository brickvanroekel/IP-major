defmodule Project.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :hashed_password, :string, null: false
      add :country, :string, null: false
      add :city, :string, null: false
      add :postal_code, :string, null: false
      add :street, :string, null: false
      add :number, :string, null: false
      add :role, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email],
             name: :unique_users_index
           )

  end
end
