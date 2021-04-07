defmodule Project.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
    field :country, :string
    field :city, :string
    field :postal_code, :string
    field :street, :string
    field :number, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :country, :city, :postal_code, :street, :number])
    |> validate_required([:first_name, :last_name, :email, :password, :country, :city, :postal_code, :street, :number])
    |> unique_constraint(:email, name: :unique_users_index,
      message:
        "E-mail already in use."
    )
  end
end
