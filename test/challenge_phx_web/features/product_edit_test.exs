defmodule ChallengePhxWeb.ProductEditTest do
  use ChallengePhxWeb.ConnCase
  use ChallengePhxWeb.RepoCase

  import ChallengePhxWeb.Router.Helpers
  import Wallaby.Query
  import Wallaby.Browser

  require IEx

  @tag :drop_products
  @tag :insert_one_product
  @tag :new_product_params
  test "edit an existing product", %{
    conn: conn,
    product: product,
    new_product_params: new_product_params,
    session: session
  } do
    session
    |> visit(product_path(conn, :edit, product.id))
    |> find(css(".product-form"), fn form ->
      form
      |> fill_in(text_field("Sku"), with: new_product_params.sku)
      |> fill_in(text_field("Name"), with: new_product_params.name)
      |> fill_in(text_field("Description"), with: new_product_params.description)
      |> fill_in(text_field("Quantity"), with: new_product_params.quantity)
      |> fill_in(text_field("Price"), with: new_product_params.price)
      |> fill_in(text_field("Ean"), with: new_product_params.ean)
      |> click(button("Submit"))
    end)
    |> find(css(".table"), fn table ->
      table |> assert_has(link(new_product_params.sku))
      table |> assert_text(new_product_params.name)
      table |> assert_text(new_product_params.description)
      table |> assert_text("#{new_product_params.quantity}")
      table |> assert_text("#{new_product_params.price}")
      table |> assert_text(new_product_params.ean)
    end)

    session |> assert_text("#{new_product_params.name} updated!")
    session |> assert_text("Product List")
    assert current_path(session) == product_path(conn, :index)
  end
end
