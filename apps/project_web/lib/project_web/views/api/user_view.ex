defmodule ProjectWeb.Api.UserView do
  use ProjectWeb, :view
  alias ProjectWeb.Api.{UserView,ProductView}

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")} # Create a json with key = data & value = an array of users. The render_many is used to call render on every attribute in the (users)-list
  end

  def render("show.json", %{orders: orders}) do
    %{data: render_many(orders, UserView, "orders.json")} # Create a json with key = data & value = an array of orders. The render_many is used to call render on every attribute in the (orders)-list
  end

  def render("user.json", %{user: user}) do # render(show.json, user) & render(overview.json, users) call this function to know how to exactly create a json of a user attribute.
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      country: user.country,
      city: user.city,
      postal_code: user.postal_code,
      street: user.street,
      number: user.number
    }
  end

  def render("orders.json", %{order: order}) do
    %{
      id: order.id,
      total_price: order.total_price,
      #products: render_many(order.products, ProductView, "product.json")
    }
  end

end
