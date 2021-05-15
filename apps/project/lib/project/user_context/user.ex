defmodule Project.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Project.OrderContext.Order

  @acceptable_roles ["Admin", "User"]

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :country, :string
    field :city, :string
    field :postal_code, :string
    field :street, :string
    field :number, :string
    field :role, :string, default: "User"
    has_many :orders, Order


    timestamps()
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :country, :city, :postal_code, :street, :number, :role])
    |> validate_required([:first_name, :last_name, :email, :password, :country, :city, :postal_code, :street, :number, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> cast_assoc(:orders)
    |> unique_constraint(:email, name: :unique_users_index,
      message:
        "E-mail already in use."
    )
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
