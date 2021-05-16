defmodule Project.UserContext.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "api_keys" do
    field :key, :string
    #field :user_id, :id
    belongs_to :user, Project.UserContext.User
    timestamps()
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:key])
    |> validate_required([:key])
  end
end
