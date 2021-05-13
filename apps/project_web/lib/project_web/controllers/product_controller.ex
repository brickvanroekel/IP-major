defmodule ProjectWeb.ProductController do
  use ProjectWeb, :controller

  alias Project.UserContext
  alias Project.ProductContext
  alias Project.ProductContext.Product

  def new(conn, _parameters) do
    changeset = ProductContext.change_product(%Product{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset,  acceptable_roles: roles)
  end

  def create(conn, %{"product" => product_params}) do
    case ProductContext.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product #{product.title} created successfully.")
        |> redirect(to: Routes.product_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def createBulk(conn, %{"product" => product_params}) do
    IO.inspect product_params
  end

  def overview(conn, _params) do
    products = ProductContext.list_products()
    render(conn, "overview.html", products: products)
  end

  def show(conn, %{"product_id" => id}) do
    product = ProductContext.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"product_id" => id}) do
    product = ProductContext.get_product!(id)
    changeset = ProductContext.change_product(product)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", product: product, changeset: changeset, acceptable_roles: roles)
  end

  def update(conn, %{"product_id" => id, "product" => product_params}) do
    product = ProductContext.get_product!(id)

    case ProductContext.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"product_id" => id}) do
    product = ProductContext.get_product!(id)
    {:ok, _product} = ProductContext.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: Routes.product_path(conn, :overview))
  end


end
