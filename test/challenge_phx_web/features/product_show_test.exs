defmodule ChallengePhxWeb.ProductShowTest do
  use ChallengePhxWeb.ConnCase

  import ChallengePhxWeb.Router.Helpers
  import Wallaby.Browser, only: [has_text?: 2, visit: 2, current_path: 1, assert_text: 2]
  
  alias ChallengePhx.Repo
  alias ChallengePhx.Product
  alias ChallengePhx.Products

  require IEx

  @valid_product_params  %{
    sku: "SKUUU-AASSDFFGG",
    name: "Product Name",
    description: "Product Name with a looooooong string ........",
    quantity: 300,
    price: 99.9,
    ean: "ADFAASDFA",
  }


  setup tags do
    if tags[:insert_one_product] do
      {:ok, product} = Products.insert  @valid_product_params
      {:ok, product: product}
    else
      {:ok, dummy: :dumb}
    end
  end


  test "to show an non existing product", %{conn: conn, session: session} do
    session
    |> visit(product_path(conn, :show, "NONEXISTINGID"))
    |> assert_text("Product NONEXISTINGID not found.")
    assert current_path(session) == product_path conn, :index
  end

  @tag :insert_one_product
  test "to show a existing product", %{conn: conn, product: product, session: session} do

    session
    |> visit product_path(conn, :show, product.id)

    session |> assert_text("Show product")
    session |> assert_text(@valid_product_params.name)
    session |> assert_text(@valid_product_params.description)
    session |> assert_text("#{@valid_product_params.price}")
    session |> assert_text("#{@valid_product_params.quantity}")
    session |> assert_text(@valid_product_params.ean)

    assert current_path(session) == product_path(conn, :show, product.id)
  end
end
