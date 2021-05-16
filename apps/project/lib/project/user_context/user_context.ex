defmodule Project.UserContext do
  alias __MODULE__.User
  alias Project.Repo

  @doc "Returns a user changeset"
  def change_user(%User{} = user) do
    user |> User.changeset(%{})
  end

  @doc "Creates a user based on some external attributes"
  def create_user(attributes) do
    %User{}
    |> User.changeset(attributes)
    |> Repo.insert()
  end

  @doc "Returns a specific user or raises an error"
  def get_user!(id), do: Repo.get!(User, id)

  @doc "Returns all users in the system"
  def list_users, do: Repo.all(User)

  @doc "Update an existing user with external attributes"
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc "Delete a user"
  def delete_user(%User{} = user), do: Repo.delete(user)

  defdelegate get_acceptable_roles(), to: User

  def authenticate_user(email, plain_text_password) do
    case Repo.get_by(User, email: email) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Argon2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def get_user(id), do: Repo.get(User, id)

  def set_token_on_user(user) do
    attrs = %{
      "verification_token" => SecureRandom.urlsafe_base64(),
      "verification_sent_at" => NaiveDateTime.utc_now()
    }
  
    user
    |> User.changeset(attrs)
    |> Repo.update!()
  end

  def get_user_from_token(token) do
    Repo.get_by(User, verification_token: token)
  end

  def valid_token?(token_sent_at) do
    current_time = NaiveDateTime.utc_now()
    Time.diff(current_time, token_sent_at) < 86400
  end
  
end
