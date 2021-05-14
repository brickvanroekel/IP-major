defmodule ProjectWeb.ProductView do
  use ProjectWeb, :view

  alias Project.Workers.CartAgent

  def cart_link(conn, product) do
    current_user = Guardian.Plug.current_resource(conn)
    if in_cart?(current_user.email, product.id) do
      link "Remove from cart", to: Routes.cart_path(conn, :delete, product.id), method: :delete
    else
      link "Add to cart", to: Routes.cart_path(conn, :update, product.id), method: :put
    end
  end

  defp in_cart?(email, product_id) do
    email
    |> existing_ids()
    |> Enum.member?(product_id)
  end

  defp existing_ids(email) do
    case CartAgent.get_cart(email) do
      nil ->
        []

      cart ->
        Enum.map(cart, &(&1.id))

    end
  end


end
