defmodule ChallengePhxWeb.ProductEditTest do
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

  @valid_product_params_update  %Product{
    sku: "SKUUU-BBBBB",
    name: "New product name",
    description: "New product description",
    quantity: 199,
    price: 98,
    ean: "EAN998899766",
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
  test "edit an existing product", %{conn: conn, product: product} do

    conn = get conn, "/"
    navigate_to product_path(conn, :edit, product.id)

    fill_field find_element(:id, "product_sku"), @valid_product_params_update.sku
    fill_field find_element(:id, "product_name"), @valid_product_params_update.name
    fill_field find_element(:id, "product_description"), @valid_product_params_update.description
    fill_field find_element(:id, "product_quantity"), @valid_product_params_update.quantity
    fill_field find_element(:id, "product_price"), @valid_product_params_update.price
    fill_field find_element(:id, "product_ean"), @valid_product_params_update.ean

    click find_element(:id, "product_submit")
    
    table_element = find_element(:class, "table")
    find_within_element(table_element, :link_text, @valid_product_params_update.sku)

    assert current_path() == product_path(conn, :index)
    assert page_source() =~ "Product List"
    assert page_source() =~  "#{@valid_product_params_update.name} updated!"
    assert page_source() =~  @valid_product_params_update.name
    assert page_source() =~  @valid_product_params_update.description
    # assert page_source() =~  @valid_product_params.price # arrumar regex
    # assert page_source() =~  @valid_product_params.quantity
    assert page_source() =~  @valid_product_params_update.ean
  end
end
