defmodule ChallengePhxWeb.ProductShowTest do
  use ChallengePhxWeb.ConnCase
  use ChallengePhxWeb.RepoCase

  import ChallengePhxWeb.Router.Helpers
  import Wallaby.Browser

  require IEx

  @tag :delete_all
  test "to show an non existing product", %{conn: conn, session: session} do
    session
    |> visit(product_path(conn, :show, "NONEXISTINGID"))
    |> assert_text("Product NONEXISTINGID not found.")

    assert current_path(session) == product_path(conn, :index)
  end

  @tag :insert_one_product
  test "to show a existing product", %{conn: conn, product: product, session: session} do
    session
    |> visit(product_path(conn, :show, product.id))

    session |> assert_text("Show product")
    session |> assert_text(product.name)
    session |> assert_text(product.description)
    session |> assert_text("#{product.price}")
    session |> assert_text("#{product.quantity}")
    session |> assert_text(product.ean)

    assert current_path(session) == product_path(conn, :show, product.id)
  end
end
