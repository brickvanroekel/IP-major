defmodule Project.UserContext do
  alias __MODULE__.User
  alias Project.Repo
  import Ecto.Query, warn: false

  alias Project.UserContext.ApiKey

  @doc "Returns a user changeset"
  def change_user(%User{} = user) do
    user |> User.changeset(%{})
  end

  @doc "Creates a user based on some external attributes"
  def create_user(attributes) do
    %User{}
    |> Repo.preload(:orders)
    |> Repo.preload(:api_key)
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
  
  def generate_user_api_key(%User{} = user) do
    key = 10
      |> :crypto.strong_rand_bytes()
      |> Base.encode16()
    user = preload_api_key(user)
    case user.api_key do
      nil ->
        %ApiKey{user_id: user.id}
      api_key ->
        api_key
    end
    |> ApiKey.changeset(%{key: key})
    |> Repo.insert_or_update()
  end


  def preload_api_key(user) do
    Repo.preload(user, :api_key)
  end


  def api_key_exists?(key) when is_nil(key), do: false
  def api_key_exists?(key) do
    qry = from api_key in ApiKey,
              where: api_key.key == ^key
    Repo.exists?(qry)
  end
end
