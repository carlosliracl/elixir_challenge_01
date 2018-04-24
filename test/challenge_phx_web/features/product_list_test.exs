defmodule ChallengePhxWeb.ProductListTest do
  use ChallengePhxWeb.ConnCase
  import Wallaby.Query
  import Wallaby.Browser
  import ChallengePhxWeb.Router.Helpers
  alias ChallengePhx.Repo
  alias ChallengePhx.Product
  alias ChallengePhx.Products

  require IEx

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

  setup tags do
    if tags[:drop_products] do
      Exredis.Api.keys("*")
      |> Enum.each(&(Exredis.Api.del(&1)))
      Repo.delete_all(Product)
      ChallengePhx.ElasticCache.drop
    end
    if tags[:create_products] do
      Products.insert  @valid_product_params
      Products.insert  @valid_product_params2
    end
    {:ok, dummy: :dumb}
  end

  @tag :drop_products
  test "show no record found message when empty list", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> assert_text("No records found")
  end

  @tag :drop_products
  @tag :create_products
  test "show a list of products", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> find(css(".table"), fn(table) ->
      table |> assert_has(link(@valid_product_params.sku))
      table |> assert_text(@valid_product_params.name)
      table |> assert_text(@valid_product_params.description)
      table |> assert_text("#{@valid_product_params.quantity}")
      table |> assert_text("#{@valid_product_params.price}")
      table |> assert_text(@valid_product_params.ean)

      table |> assert_has(link(@valid_product_params2.sku))
      table |> assert_text(@valid_product_params2.name)
      table |> assert_text(@valid_product_params2.description)
      table |> assert_text("#{@valid_product_params2.quantity}")
      table |> assert_text("#{@valid_product_params2.price}")
      table |> assert_text(@valid_product_params2.ean)
    end)
    assert page_source(session) =~ "No records found" == false
  end

  @tag :drop_products
  test "search a non existing product", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> fill_in(text_field("Search term"), with: "Non Existing Text")
    |> click(button("Search"))

    assert current_path(session) == product_path(conn, :index)
    session |> assert_text("Product List")
    session |> assert_text("No records found")
  end

  @tag :drop_products
  @tag :create_products
  test "search a existing product", %{conn: conn, session: session} do
    session
    |> visit("/")
    |> click(css("#list_products"))
    |> fill_in(text_field("Search term"), with: @valid_product_params.sku)
    |> click(button("Search"))
    |> find(css(".table"), fn(table) ->
      table |> assert_has(link(@valid_product_params.sku))
      table |> assert_text(@valid_product_params.name)
      table |> assert_text(@valid_product_params.description)
      table |> assert_text("#{@valid_product_params.quantity}")
      table |> assert_text("#{@valid_product_params.price}")
      table |> assert_text(@valid_product_params.ean)
    end)

    assert current_path(session) == product_path conn, :index
    session |> assert_text("Product List")
    assert page_source(session) =~ "No records found" == false
  end
end
