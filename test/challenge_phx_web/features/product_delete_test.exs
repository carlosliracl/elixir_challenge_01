defmodule ChallengePhxWeb.ProductShowTest do
  use ChallengePhxWeb.ConnCase
  # Import Hound helpers
  use Hound.Helpers
  import ChallengePhxWeb.Router.Helpers
  alias ChallengePhx.Repo
  alias ChallengePhx.Product

  require IEx
  # Start a Hound session
  hound_session()

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
  test "to delete a existing product", %{conn: conn, product: product} do
    conn = get conn, "/"
    navigate_to product_path(conn, :show, product.id)

    find_element(:id, "product_delete_button") |> click
    accept_dialog()

    assert current_path() == product_path(conn, :index)
    assert page_source() =~ "Product List"
    assert page_source() =~  @valid_product_params.name == false
    assert page_source() =~  @valid_product_params.description  == false
    assert page_source() =~  @valid_product_params.ean == false
  end
end
