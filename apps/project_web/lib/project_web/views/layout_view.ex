defmodule ProjectWeb.LayoutView do
  use ProjectWeb, :view

  alias Project.Workers.CartAgent

  def cart_item_count(conn) do
    current_user = Guardian.Plug.current_resource(conn)
    case CartAgent.get_cart(current_user.email) do
      nil ->
        0
      cart ->
        Enum.count(cart)
    end
  end
end
