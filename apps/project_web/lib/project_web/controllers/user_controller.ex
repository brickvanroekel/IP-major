defmodule ProjectWeb.UserController do
  use ProjectWeb, :controller

  alias Project.UserContext
  alias Project.UserContext.User
  alias Project.{Mailer, Email}

  def new(conn, _parameters) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "register.html", changeset: changeset,  acceptable_roles: roles)
  end

  defp send_registration_notification(user) do
    Email.register_email(user) |> Mailer.deliver_later()
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        send_registration_notification(user)
        conn
        |> UserContext.set_token_on_user(user)
        |> put_flash(:info, "User #{user.first_name} #{user.last_name} created successfully! Confirm your email.")
        |> redirect(to: Routes.user_path(conn, :overview))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  def overview(conn, _params) do
    users = UserContext.list_users()
    render(conn, "overview.html", users: users)
  end

  def show(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
  end

  def update(conn, %{"user_id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :overview))
  end

  def update_verification(conn, %{"id" => token, "user" => verification_attrs}) do
    user = UserContext.get_user_from_token(token)
  
    verification_attrs =
      Map.merge(verification_attrs, %{"verification_token" => nil, "verification_sent_at" => nil})
  
    with true <- UserContext.valid_token?(user.verification_sent_at),
         {:ok, _updated_user} <- UserContext.update_user(user, pass_attrs) do
  
         conn
         |> put_flash(:info, "Your account has been verified.")
         |> redirect(to: Routes.session_path(conn, :new))
  
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Problem verifying your account")
        |> redirect(to: Routes.session_path(conn, :new))
  
      false ->
        conn
        |> put_flash(:error, "Verification token expired - request new one")
        |> redirect(to: Routes.session_path(conn, :new))
  
    end
  end
end
