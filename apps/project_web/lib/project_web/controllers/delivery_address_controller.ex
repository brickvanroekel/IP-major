defmodule ProjectWeb.DeliveryAddressController do
  use ProjectWeb, :controller
  alias Project.OrderContext
  alias Project.DeliveryAddressContext
  alias Project.DeliveryAddressContext.DeliveryAddress
  alias Project.UserContext

  #plug ProjectWeb.Plugs.CheckAuth
  def new(conn, _parameters) do
    changeset = DeliveryAddressContext.change_delivery_address(%DeliveryAddress{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset,  acceptable_roles: roles)
  end

  def create(conn, %{"delivery_address" => delivery_address_params}) do
    case DeliveryAddressContext.create_delivery_address(delivery_address_params) do
      {:ok, delivery_address_params} ->
        conn
        |> put_flash(:info, "Address added successfully.")
        |> redirect(to: Routes.order_path(conn, :create, delivery_address_params: delivery_address_params))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
