defmodule ChallengePhxWeb.ProductCreateTest do
  use ChallengePhxWeb.ConnCase
  import Wallaby.Browser
  import Wallaby.Query

  import ChallengePhxWeb.Router.Helpers
  alias ChallengePhx.Repo
  alias ChallengePhx.Product

  require IEx

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

  test "try to create a valid product", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn(form) ->
      form
      |> fill_in(text_field("Sku"), with:  @valid_product_params.sku)
      |> fill_in(text_field("Name"), with:  @valid_product_params.name)
      |> fill_in(text_field("Description"), with: @valid_product_params.description)
      |> fill_in(text_field("Quantity"), with: @valid_product_params.quantity)
      |> fill_in(text_field("Price"), with: @valid_product_params.price)
      |> fill_in(text_field("Ean"), with: @valid_product_params.ean)
      |> click(button("Submit"))
    end)
    |> find(css(".table"), fn(table) ->
      table |> assert_has(link(@valid_product_params.sku))
      table |> assert_text(@valid_product_params.name)
      table |> assert_text(@valid_product_params.description)
      table |> assert_text("#{@valid_product_params.quantity}")
      table |> assert_text("#{@valid_product_params.price}")
      table |> assert_text(@valid_product_params.ean)
    end)

    session |> assert_text("#{@valid_product_params.name} created!")
    session |> assert_text("Product List")
    assert current_path(session) == product_path conn, :index
  end

  test "try to create a product without params", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn(form) ->
      form
      |> click(button("Submit"))
    end)

    assert current_path(session) == product_path conn, :index #should be :new
    session |> assert_text("Create a product")
    session |> assert_text(":sku, {\"can't be blank\"")
    session |> assert_text(":name, {\"can't be blank\"")
    session |> assert_text(":description, {\"can't be blank\"")
    session |> assert_text(":quantity, {\"can't be blank\"")
    session |> assert_text(":price, {\"can't be blank\"")
    session |> assert_text(":ean, {\"can't be blank\"")
  end

  test "try to create a product with price lower than 0", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn(form) ->
      form
      |> fill_in(text_field("Sku"), with:  @valid_product_params.sku)
      |> fill_in(text_field("Name"), with:  @valid_product_params.name)
      |> fill_in(text_field("Description"), with: @valid_product_params.description)
      |> fill_in(text_field("Quantity"), with: @valid_product_params.quantity)
      |> fill_in(text_field("Price"), with: -1)
      |> fill_in(text_field("Ean"), with: @valid_product_params.ean)
      |> click(button("Submit"))
    end)
    assert current_path(session) == product_path(conn, :index) #should be :new
    session |> assert_text("Create a product")
    session |> assert_text(":price, {\"must be greater than %{number}\"")
  end

  test "try to create a product with small ean", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn(form) ->
      form
      |> fill_in(text_field("Sku"), with:  @valid_product_params.sku)
      |> fill_in(text_field("Name"), with:  @valid_product_params.name)
      |> fill_in(text_field("Description"), with: @valid_product_params.description)
      |> fill_in(text_field("Quantity"), with: @valid_product_params.quantity)
      |> fill_in(text_field("Price"), with: @valid_product_params.price)
      |> fill_in(text_field("Ean"), with: "1234")
      |> click(button("Submit"))
    end)

    assert current_path(session) == product_path conn, :index #should be :new
    session |> assert_text("Create a product")
    session |> assert_text(":ean, {\"should be at least %{count} character(s)\"")
  end


  test "try to create a product with large ean", %{conn: conn, session: session} do
   
     session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn(form) ->
      form
      |> fill_in(text_field("Sku"), with:  @valid_product_params.sku)
      |> fill_in(text_field("Name"), with:  @valid_product_params.name)
      |> fill_in(text_field("Description"), with: @valid_product_params.description)
      |> fill_in(text_field("Quantity"), with: @valid_product_params.quantity)
      |> fill_in(text_field("Price"), with: @valid_product_params.price)
      |> fill_in(text_field("Ean"), with: "01234567890123456789")
      |> click(button("Submit"))
    end)
   
    assert current_path(session) == product_path conn, :index #should be :new
    session |> assert_text("Create a product")
    session |> assert_text(":ean, {\"should be at most %{count} character(s)\"")
  end

  test "try to create a product with invalid sku", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn(form) ->
      form
      |> fill_in(text_field("Sku"), with:  "!@##!@#%%&%%%")
      |> fill_in(text_field("Name"), with:  @valid_product_params.name)
      |> fill_in(text_field("Description"), with: @valid_product_params.description)
      |> fill_in(text_field("Quantity"), with: @valid_product_params.quantity)
      |> fill_in(text_field("Price"), with: @valid_product_params.price)
      |> fill_in(text_field("Ean"), with: @valid_product_params.ean)
      |> click(button("Submit"))
    end)

    assert current_path(session) == product_path conn, :index #should be :new
    session |> assert_text("Create a product")
    session |> assert_text(":sku, {\"has invalid format\"")
  end


  test "try to create a product with a duplicated sku", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn(form) ->
      form
      |> fill_in(text_field("Sku"), with:  @valid_product_params.sku)
      |> fill_in(text_field("Name"), with:  @valid_product_params.name)
      |> fill_in(text_field("Description"), with: @valid_product_params.description)
      |> fill_in(text_field("Quantity"), with: @valid_product_params.quantity)
      |> fill_in(text_field("Price"), with: @valid_product_params.price)
      |> fill_in(text_field("Ean"), with: @valid_product_params.ean)
      |> click(button("Submit"))
    end)
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn(form) ->
      form
      |> fill_in(text_field("Sku"), with:  @valid_product_params.sku)
      |> fill_in(text_field("Name"), with:  @valid_product_params.name)
      |> fill_in(text_field("Description"), with: @valid_product_params.description)
      |> fill_in(text_field("Quantity"), with: @valid_product_params.quantity)
      |> fill_in(text_field("Price"), with: @valid_product_params.price)
      |> fill_in(text_field("Ean"), with: @valid_product_params.ean)
      |> click(button("Submit"))
    end)

    assert current_path(session) == product_path conn, :index #should be :new
    session |> assert_text("Create a product")
    session |> assert_text(":sku, {\"has already been taken\"")
  end
end
