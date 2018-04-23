defmodule ChallengePhxWeb.ProductEditTest do
  use ChallengePhxWeb.ConnCase

  import ChallengePhxWeb.Router.Helpers
  import Wallaby.Query
  import Wallaby.Browser

  alias ChallengePhx.Product
  alias ChallengePhx.Products

  require IEx

  @valid_product_params  %{
    sku: "SKUUU-AASSDFFGG",
    name: "Product Name",
    description: "Product Name with a looooooong string ........ ",
    quantity: 300,
    price: 99.9,
    ean: "ADFAASDFA",
  }

  @valid_product_params_update  %{
    sku: "SKUUU-BBBBB",
    name: "New product name",
    description: "New product description",
    quantity: 199,
    price: 98,
    ean: "EAN998899766",
  }

  setup tags do
    if tags[:insert_one_product] do
      {:ok, product} = Products.insert  @valid_product_params
      {:ok, product: product}
    else
      {:ok, dummy: :dumb}
    end
  end

  @tag :insert_one_product
  test "edit an existing product", %{conn: conn, product: product, session: session} do
    session
    |> visit(product_path(conn, :edit, product.id))
    |> find(css(".product-form"), fn(form) ->
      form
      |> fill_in(text_field("Sku"), with:  @valid_product_params_update.sku)
      |> fill_in(text_field("Name"), with:  @valid_product_params_update.name)
      |> fill_in(text_field("Description"), with: @valid_product_params_update.description)
      |> fill_in(text_field("Quantity"), with: @valid_product_params_update.quantity)
      |> fill_in(text_field("Price"), with: @valid_product_params_update.price)
      |> fill_in(text_field("Ean"), with: @valid_product_params_update.ean)
      |> click(button("Submit"))
    end)
    |> find(css(".table"), fn(table) ->
      table |> assert_has(link(@valid_product_params_update.sku))
      table |> assert_text(@valid_product_params_update.name)
      table |> assert_text(@valid_product_params_update.description)
      table |> assert_text("#{@valid_product_params_update.quantity}")
      table |> assert_text("#{@valid_product_params_update.price}")
      table |> assert_text(@valid_product_params_update.ean)
    end)

    session |> assert_text("#{@valid_product_params_update.name} updated!")
    session |> assert_text("Product List")
    assert current_path(session) == product_path conn, :index
  end
end
