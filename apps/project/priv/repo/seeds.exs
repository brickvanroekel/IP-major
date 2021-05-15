# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Project.Repo.insert!(%Project.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
{:ok, _cs} = Project.UserContext.create_user(%{"password" => "t", "role" => "User", "first_name" => "test", "last_name" => "user", "email" => "user@test.com", "country" => "BE", "city" => "Leuven", "postal_code" => "3000", "street" => "Tiensestraat", "number" => "200"})

{:ok, _cs} = Project.UserContext.create_user(%{"password" => "t", "role" => "Admin", "first_name" => "test", "last_name" => "admin", "email" => "admin@test.com", "country" => "BE", "city" => "Leuven", "postal_code" => "3000", "street" => "Tiensestraat", "number" => "200"})

{:ok, _cs} = Project.ProductContext.create_product(%{"title" => "Schoen", "description" => "mooie schoen", "size" => "groot", "color" => "groen", "price" => 10.50})
