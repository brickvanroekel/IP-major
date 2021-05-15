defmodule ProjectWeb.LayoutView do
  use ProjectWeb, :view

  alias Project.Carts

  def cart_item_count(conn) do
    current_user = Guardian.Plug.current_resource(conn)
    case current_user do
      nil ->
        0
      current_user ->
        case Carts.get(current_user.email) do
          nil ->
            0
          cart ->
            Enum.count(cart)
        end
    end
  end
end
