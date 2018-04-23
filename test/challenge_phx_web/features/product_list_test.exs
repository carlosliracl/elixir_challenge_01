defmodule ChallengePhxWeb.ProductListTest do
  use ChallengePhxWeb.ConnCase
  # Import Hound helpers
  use Hound.Helpers
  import ChallengePhxWeb.Router.Helpers
  alias ChallengePhx.Repo
  alias ChallengePhx.Product
  alias ChallengePhx.Products

  require IEx
  # Start a Hound session
  hound_session()

  @valid_product_params  %{
    sku: "ADFAASDFA-SDFA1231231",
    name: "Product Name",
    description: "Product Name with a looooooong string ........ ",
    quantity: 300,
    price: 99.9,
    ean: "ADFAASDFA",
  }
  @valid_product_params2  %{
    sku: "SKU-1231231",
    name: "Second Product Name",
    description: "Product with a string",
    quantity: 200,
    price: 29.9,
    ean: "EEEAAANNNN",
  }

  defp create_products(_) do
    Products.insert  @valid_product_params
    Products.insert  @valid_product_params2
    {:ok, dummy: :dumb}
  end

  defp drop_products(_) do
    Repo.delete_all Product
    {:ok, dummy: :dumb}
  end

  describe "With empty list" do
    setup [:drop_products]

    test "show no record found message when empty list", %{conn: conn} do
      conn = get conn, "/"
      navigate_to "/"

      link_products_page = find_element :id, "list_products"
      click link_products_page

      assert page_source() =~ "No records found"
    end
  end

  describe "List products" do
    setup [:drop_products, :create_products]

    test "show a list of products", %{conn: conn} do

      conn = get conn, "/"
      navigate_to "/"

      link_products_page = find_element :id, "list_products"
      click link_products_page

      table_element = find_element(:class, "table")
      find_within_element(table_element, :link_text, @valid_product_params.sku)
      find_within_element(table_element, :link_text, @valid_product_params2.sku)

      assert current_path() == product_path conn, :index
      assert page_source() =~ "Product List"
      assert page_source() =~  @valid_product_params.name
      assert page_source() =~  @valid_product_params.description
      # assert page_source() =~  @valid_product_params.price # arrumar regex
      # assert page_source() =~  @valid_product_params.quantity
      assert page_source() =~  @valid_product_params.ean

      assert page_source() =~  @valid_product_params2.name
      assert page_source() =~  @valid_product_params2.description
      # assert page_source() =~  @valid_product_params2.price # arrumar regex
      # assert page_source() =~  @valid_product_params2.quantity
      assert page_source() =~  @valid_product_params2.ean

      assert page_source() =~  "No records found" == false
    end


    test "search a non existing product", %{conn: conn} do

      conn = get conn, "/"
      navigate_to "/"

      link_products_page = find_element :id, "list_products"
      click link_products_page

      fill_field find_element(:id, "product_search_input"), "Non Existing Text"

      button_search = find_element :id, "product_search_button"
      click button_search

      assert current_path() == product_path conn, :index
      assert page_source() =~ "Product List"
      assert page_source() =~  "No records found"
    end

    test "search a existing product", %{conn: conn} do

      conn = get conn, "/"
      navigate_to "/"

      link_products_page = find_element :id, "list_products"
      click link_products_page

      fill_field find_element(:id, "product_search_input"), @valid_product_params.sku

      button_search = find_element :id, "product_search_button"
      click button_search

      table_element = find_element(:class, "table")
      find_within_element(table_element, :link_text, @valid_product_params.sku)

      assert current_path() == product_path conn, :index
      assert page_source() =~ "Product List"
      assert page_source() =~  "No records found" == false
      assert page_source() =~ @valid_product_params.sku
      assert page_source() =~ @valid_product_params.name
    end
  end
end
