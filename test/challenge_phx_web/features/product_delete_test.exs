defmodule ChallengePhxWeb.ProductShowTest do
  use ChallengePhxWeb.ConnCase

  import Wallaby.Query
  import Wallaby.Browser

  import ChallengePhxWeb.Router.Helpers
  alias ChallengePhx.Repo
  alias ChallengePhx.Product

  require IEx

  @valid_product_params  %Product{
    sku: "SKUUU-AASSDFFGG",
    name: "Product Name",
    description: "Product Name with a looooooong string ........ ",
    quantity: 300,
    price: 99.9,
    ean: "ADFAASDFA",
  }

  setup tags do
    if tags[:insert_one_product] do
      {:ok, product} = Repo.insert  @valid_product_params
      {:ok, product: product}
    else
      {:ok, dummy: :dumb}
    end
  end

  @tag :insert_one_product
  test "to delete a existing product", %{conn: conn, product: product, session: session} do
    session
    |> visit(product_path(conn, :show, product.id))
    |> click(css("#product_delete_button"))
    |> accept_dialogs
    
    session |> assert_text("No records found")
    assert current_path(session) == product_path(conn, :index)
  end
end
