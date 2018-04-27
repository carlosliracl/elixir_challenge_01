defmodule WebsiteWeb.ProductCreateTest do
  use WebsiteWeb.ConnCase

  import Wallaby.Browser
  import Wallaby.Query
  import WebsiteWeb.Router.Helpers
  import Website.Factory

  alias Website.Repo
  alias Website.Models.Product

  require IEx

  setup do
    Repo.delete_all(Product)
    {:ok, dummy: :dumb}
  end

  test "try to create a valid product", %{conn: conn, session: session} do
    product = build(:product)

    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn form ->
      form
      |> fill_in(text_field("Sku"), with: product.sku)
      |> fill_in(text_field("Name"), with: product.name)
      |> fill_in(text_field("Description"), with: product.description)
      |> fill_in(text_field("Quantity"), with: product.quantity)
      |> fill_in(text_field("Price"), with: product.price)
      |> fill_in(text_field("Ean"), with: product.ean)
      |> click(button("Submit"))
    end)
    |> find(css(".table"), fn table ->
      table |> assert_has(link(product.sku))
      table |> assert_text(product.name)
      table |> assert_text(product.description)
      table |> assert_text("#{product.quantity}")
      table |> assert_text("#{product.price}")
      table |> assert_text(product.ean)
    end)

    session |> assert_text("#{product.name} created!")
    session |> assert_text("Product List")
    assert current_path(session) == product_path(conn, :index)
  end

  test "try to create a product without params", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn form ->
      form
      |> click(button("Submit"))
    end)

    # should be :new
    assert current_path(session) == product_path(conn, :index)
    session |> assert_text("Create a product")
    session |> assert_text(":sku, {\"can't be blank\"")
    session |> assert_text(":name, {\"can't be blank\"")
    session |> assert_text(":description, {\"can't be blank\"")
    session |> assert_text(":quantity, {\"can't be blank\"")
    session |> assert_text(":price, {\"can't be blank\"")
    session |> assert_text(":ean, {\"can't be blank\"")
  end

  test "try to create a product with price lower than 0", %{conn: conn, session: session} do
    product = build(:product)

    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn form ->
      form
      |> fill_in(text_field("Sku"), with: product.sku)
      |> fill_in(text_field("Name"), with: product.name)
      |> fill_in(text_field("Description"), with: product.description)
      |> fill_in(text_field("Quantity"), with: product.quantity)
      |> fill_in(text_field("Price"), with: -1)
      |> fill_in(text_field("Ean"), with: product.ean)
      |> click(button("Submit"))
    end)

    # should be :new
    assert current_path(session) == product_path(conn, :index)
    session |> assert_text("Create a product")
    session |> assert_text(":price, {\"must be greater than %{number}\"")
  end

  test "try to create a product with small ean", %{conn: conn, session: session} do
    product = build(:product)

    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn form ->
      form
      |> fill_in(text_field("Sku"), with: product.sku)
      |> fill_in(text_field("Name"), with: product.name)
      |> fill_in(text_field("Description"), with: product.description)
      |> fill_in(text_field("Quantity"), with: product.quantity)
      |> fill_in(text_field("Price"), with: product.price)
      |> fill_in(text_field("Ean"), with: "1234")
      |> click(button("Submit"))
    end)

    # should be :new
    assert current_path(session) == product_path(conn, :index)
    session |> assert_text("Create a product")
    session |> assert_text(":ean, {\"should be at least %{count} character(s)\"")
  end

  test "try to create a product with large ean", %{conn: conn, session: session} do
    product = build(:product)

    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn form ->
      form
      |> fill_in(text_field("Sku"), with: product.sku)
      |> fill_in(text_field("Name"), with: product.name)
      |> fill_in(text_field("Description"), with: product.description)
      |> fill_in(text_field("Quantity"), with: product.quantity)
      |> fill_in(text_field("Price"), with: product.price)
      |> fill_in(text_field("Ean"), with: "01234567890123456789")
      |> click(button("Submit"))
    end)

    # should be :new
    assert current_path(session) == product_path(conn, :index)
    session |> assert_text("Create a product")
    session |> assert_text(":ean, {\"should be at most %{count} character(s)\"")
  end

  test "try to create a product with invalid sku", %{conn: conn, session: session} do
    product = build(:product)

    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn form ->
      form
      |> fill_in(text_field("Sku"), with: "!@##!@#%%&%%%")
      |> fill_in(text_field("Name"), with: product.name)
      |> fill_in(text_field("Description"), with: product.description)
      |> fill_in(text_field("Quantity"), with: product.quantity)
      |> fill_in(text_field("Price"), with: product.price)
      |> fill_in(text_field("Ean"), with: product.ean)
      |> click(button("Submit"))
    end)

    # should be :new
    assert current_path(session) == product_path(conn, :index)
    session |> assert_text("Create a product")
    session |> assert_text(":sku, {\"has invalid format\"")
  end

  test "try to create a product with a duplicated sku", %{conn: conn, session: session} do
    product = build(:product)

    session
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn form ->
      form
      |> fill_in(text_field("Sku"), with: product.sku)
      |> fill_in(text_field("Name"), with: product.name)
      |> fill_in(text_field("Description"), with: product.description)
      |> fill_in(text_field("Quantity"), with: product.quantity)
      |> fill_in(text_field("Price"), with: product.price)
      |> fill_in(text_field("Ean"), with: product.ean)
      |> click(button("Submit"))
    end)
    |> visit("/")
    |> click(css("#list_products"))
    |> click(css("#add_product"))
    |> find(css(".product-form"), fn form ->
      form
      |> fill_in(text_field("Sku"), with: product.sku)
      |> fill_in(text_field("Name"), with: product.name)
      |> fill_in(text_field("Description"), with: product.description)
      |> fill_in(text_field("Quantity"), with: product.quantity)
      |> fill_in(text_field("Price"), with: product.price)
      |> fill_in(text_field("Ean"), with: product.ean)
      |> click(button("Submit"))
    end)

    # should be :new
    assert current_path(session) == product_path(conn, :index)
    session |> assert_text("Create a product")
    session |> assert_text(":sku, {\"has already been taken\"")
  end
end
