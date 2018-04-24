defmodule ChallengePhxWeb.ProductListTest do
  use ChallengePhxWeb.ConnCase
  use ChallengePhxWeb.RepoCase

  import Wallaby.Query
  import Wallaby.Browser
  import ChallengePhxWeb.Router.Helpers

  require IEx

  @tag :drop_products
  test "show no record found message when empty list", %{session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> assert_text("No records found")
  end

  @tag :drop_products
  @tag :create_products
  test "show a list of products", %{session: session, products: products} do

    session
    |> visit("/")
    |> click(css("#list_products"))
    |> find(css(".table"), fn(table) ->

      Enum.each(products, fn(product) ->

        table |> assert_has(link(product.sku))
        table |> assert_text(product.name)
        table |> assert_text(product.description)
        table |> assert_text("#{product.quantity}")
        table |> assert_text("#{product.price}")
        table |> assert_text(product.ean)

      end)
    end)

    assert page_source(session) =~ "No records found" == false
  end

  @tag :drop_products
  test "search a non existing product", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> fill_in(text_field("Search term"), with: "Non Existing Text")
    |> click(button("Search"))

    assert current_path(session) == product_path(conn, :index)
    session |> assert_text("Product List")
    session |> assert_text("No records found")
  end

  @tag :drop_products
  @tag :insert_one_product
  test "search a existing product", %{conn: conn, session: session, product: product} do

    session
    |> visit("/")
    |> click(css("#list_products"))
    |> fill_in(text_field("Search term"), with: product.sku)
    |> click(button("Search"))
    |> find(css(".table"), fn(table) ->
      table |> assert_has(link(product.sku))
      table |> assert_text(product.name)
      table |> assert_text(product.description)
      table |> assert_text("#{product.quantity}")
      table |> assert_text("#{product.price}")
      table |> assert_text(product.ean)
    end)

    assert current_path(session) == product_path conn, :index
    session |> assert_text("Product List")
    assert page_source(session) =~ "No records found" == false
  end
end
