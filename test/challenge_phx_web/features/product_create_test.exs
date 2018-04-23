defmodule ChallengePhxWeb.ProductCreateTest do
  use ChallengePhxWeb.ConnCase
  # Import Hound helpers
  use Hound.Helpers
  import ChallengePhxWeb.Router.Helpers
  alias ChallengePhx.Repo
  alias ChallengePhx.Product

  require IEx
  # Start a Hound session
  hound_session()

  @valid_product_params %{
    sku: "SKU-2324ASFA",
    name: "Product Name",
    description: "Product Name with a looooooong string ........ ",
    quantity: 300,
    price: 99.90,
    ean: "ADFAASDFA",
  }

  setup do
    Repo.delete_all(Product)
    {:ok, dummy: :dumb}
  end

  test "try to create a valid product", %{conn: conn} do
    conn = get conn, "/"
    navigate_to "/"

    link_products_page = find_element :id, "list_products"
    click link_products_page

    link_add_product = find_element :id, "add_product"
    click link_add_product

    fill_field find_element(:id, "product_sku"), @valid_product_params.sku
    fill_field find_element(:id, "product_name"), @valid_product_params.name
    fill_field find_element(:id, "product_description"), @valid_product_params.description
    fill_field find_element(:id, "product_quantity"), @valid_product_params.quantity
    fill_field find_element(:id, "product_price"), @valid_product_params.price
    fill_field find_element(:id, "product_ean"), @valid_product_params.ean

    click find_element(:id, "product_submit")

    table_element = find_element(:class, "table")
    find_within_element(table_element, :link_text, @valid_product_params.sku)

    assert current_path() == product_path conn, :index
    assert page_source() =~ "Product List"
    assert page_source() =~ "#{@valid_product_params.name} created!"
  end

  test "try to create a product without params", %{conn: conn} do
    conn = get conn, "/"
    navigate_to "/"

    link_products_page = find_element :id, "list_products"
    click link_products_page

    link_add_product = find_element :id, "add_product"
    click link_add_product

    add_product_button = find_element :id, "product_submit"
    click add_product_button

    assert current_path() == product_path conn, :index #should be :new
    assert page_source() =~ "Create a product"
    assert page_source() =~ ":sku, {\"can't be blank\""
    assert page_source() =~ ":name, {\"can't be blank\""
    assert page_source() =~ ":description, {\"can't be blank\""
    assert page_source() =~ ":quantity, {\"can't be blank\""
    assert page_source() =~ ":price, {\"can't be blank\""
    assert page_source() =~ ":ean, {\"can't be blank\""
  end

  test "try to create a product with price lower than 0", %{conn: conn} do
    conn = get conn, "/"
    navigate_to "/"

    link_products_page = find_element :id, "list_products"
    click link_products_page

    link_add_product = find_element :id, "add_product"
    click link_add_product

    fill_field find_element(:id, "product_sku"), @valid_product_params.sku
    fill_field find_element(:id, "product_name"), @valid_product_params.name
    fill_field find_element(:id, "product_description"), @valid_product_params.description
    fill_field find_element(:id, "product_quantity"), @valid_product_params.quantity
    fill_field find_element(:id, "product_price"), -1
    fill_field find_element(:id, "product_ean"), @valid_product_params.ean

    click find_element(:id, "product_submit")

    add_product_button = find_element :id, "product_submit"
    click add_product_button

    assert current_path() == product_path conn, :index #should be :new
    assert page_source() =~ "Create a product"
    assert page_source() =~ ":price, {\"must be greater than %{number}\""
  end

  test "try to create a product with small ean", %{conn: conn} do
    conn = get conn, "/"
    navigate_to "/"

    link_products_page = find_element :id, "list_products"
    click link_products_page

    link_add_product = find_element :id, "add_product"
    click link_add_product

    fill_field find_element(:id, "product_sku"), @valid_product_params.sku
    fill_field find_element(:id, "product_name"), @valid_product_params.name
    fill_field find_element(:id, "product_description"), @valid_product_params.description
    fill_field find_element(:id, "product_quantity"), @valid_product_params.quantity
    fill_field find_element(:id, "product_price"), @valid_product_params.price
    fill_field find_element(:id, "product_ean"), "1234"

    click find_element(:id, "product_submit")

    add_product_button = find_element :id, "product_submit"
    click add_product_button

    assert current_path() == product_path conn, :index #should be :new
    assert page_source() =~ "Create a product"
    assert page_source() =~ ":ean, {\"should be at least %{count} character(s)\""
  end


  test "try to create a product with large ean", %{conn: conn} do
    conn = get conn, "/"
    navigate_to "/"

    link_products_page = find_element :id, "list_products"
    click link_products_page

    link_add_product = find_element :id, "add_product"
    click link_add_product

    fill_field find_element(:id, "product_sku"), @valid_product_params.sku
    fill_field find_element(:id, "product_name"), @valid_product_params.name
    fill_field find_element(:id, "product_description"), @valid_product_params.description
    fill_field find_element(:id, "product_quantity"), @valid_product_params.quantity
    fill_field find_element(:id, "product_price"), @valid_product_params.price
    fill_field find_element(:id, "product_ean"), "12345678901234567"

    click find_element(:id, "product_submit")

    add_product_button = find_element :id, "product_submit"
    click add_product_button

    assert current_path() == product_path conn, :index #should be :new
    assert page_source() =~ "Create a product"
    assert page_source() =~ ":ean, {\"should be at most %{count} character(s)\""
  end

  test "try to create a product with invalid sku", %{conn: conn} do
    conn = get conn, "/"
    navigate_to "/"

    link_products_page = find_element :id, "list_products"
    click link_products_page

    link_add_product = find_element :id, "add_product"
    click link_add_product

    fill_field find_element(:id, "product_sku"), "!@#@#$wasdf2AAsdfadf"
    fill_field find_element(:id, "product_name"), @valid_product_params.name
    fill_field find_element(:id, "product_description"), @valid_product_params.description
    fill_field find_element(:id, "product_quantity"), @valid_product_params.quantity
    fill_field find_element(:id, "product_price"), @valid_product_params.price
    fill_field find_element(:id, "product_ean"),  @valid_product_params.ean

    click find_element(:id, "product_submit")

    add_product_button = find_element :id, "product_submit"
    click add_product_button

    assert current_path() == product_path conn, :index #should be :new
    assert page_source() =~ "Create a product"
    assert page_source() =~ ":sku, {\"has invalid format\""
  end


  test "try to create a product with a duplicated sku", %{conn: conn} do
    conn = get conn, "/"
    navigate_to "/"

    link_products_page = find_element :id, "list_products"
    click link_products_page

    link_add_product = find_element :id, "add_product"
    click link_add_product

    fill_field find_element(:id, "product_sku"), @valid_product_params.sku
    fill_field find_element(:id, "product_name"), @valid_product_params.name
    fill_field find_element(:id, "product_description"), @valid_product_params.description
    fill_field find_element(:id, "product_quantity"), @valid_product_params.quantity
    fill_field find_element(:id, "product_price"), @valid_product_params.price
    fill_field find_element(:id, "product_ean"), @valid_product_params.ean

    click find_element(:id, "product_submit")


    navigate_to "/"

    link_products_page = find_element :id, "list_products"
    click link_products_page

    link_add_product = find_element :id, "add_product"
    click link_add_product

    fill_field find_element(:id, "product_sku"), @valid_product_params.sku
    fill_field find_element(:id, "product_name"), @valid_product_params.name
    fill_field find_element(:id, "product_description"), @valid_product_params.description
    fill_field find_element(:id, "product_quantity"), @valid_product_params.quantity
    fill_field find_element(:id, "product_price"), @valid_product_params.price
    fill_field find_element(:id, "product_ean"), @valid_product_params.ean

    click find_element(:id, "product_submit")

    assert current_path() == product_path conn, :index
    assert page_source() =~ "Create a product"
    assert page_source() =~ ":sku, {\"has already been taken\""
  end
end
