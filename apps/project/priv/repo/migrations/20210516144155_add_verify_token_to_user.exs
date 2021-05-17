defmodule Project.Repo.Migrations.AddVerifyTokenToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :verification_token, :string
      add :verification_sent_at, :naive_datetime
    end
  end
end
