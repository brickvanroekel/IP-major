defmodule Project.Email do
  use Bamboo.Phoenix, view: ProjectWeb.EmailView

    def register_email(user) do
      base_email(user)
      |> assign(:user, user)
      |> subject("User Registration")
      |> render("confirmation_mail.html")
    end

    def order_email(cart,user) do
      base_email(user)
      |> subject("Order confirmation")
      |> assign(:cart, cart)
      |> render("order_confirmation.html")
    end

    defp base_email(user) do
      new_email
      |> from("no-reply@webshop.com")
      |> to(user.email)
      |> put_html_layout({ProjectWeb.LayoutView, "email.html"})
    end
end
