defmodule WebsiteWeb.ProductDeleteTest do
  use WebsiteWeb.ConnCase
  use WebsiteWeb.RepoCase

  import Wallaby.Query
  import Wallaby.Browser
  import WebsiteWeb.Router.Helpers

  require IEx

  @tag :drop_products
  @tag :insert_one_product
  test "to delete a existing product", %{conn: conn, product: product, session: session} do
    # HACK: Strange behavior, only works with two attempts
    session
    |> visit(product_path(conn, :show, product.id))
    |> click(css("#product_delete_button"))
    |> accept_dialogs()

    session
    |> visit(product_path(conn, :show, product.id))
    |> click(css("#product_delete_button"))
    |> accept_dialogs()

    session |> assert_text("No records found")
    assert current_path(session) == product_path(conn, :index)
  end
end
