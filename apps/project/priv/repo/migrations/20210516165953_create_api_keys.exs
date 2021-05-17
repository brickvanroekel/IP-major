defmodule Project.Repo.Migrations.CreateApiKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys) do
      add :key, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:api_keys, [:user_id, :key])
  end
end
