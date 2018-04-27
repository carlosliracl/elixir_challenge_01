defmodule WebsiteWeb.RepoCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  import Website.Factory
  alias Website.Repo
  alias Website.Models.Product
  alias Website.Models.Products
  alias Website.Cache.Elasticsearch
  require IEx

  setup tags do
    result = []

    if tags[:drop_products] do
      drop_contents()
    end

    if tags[:insert_one_product] do
      {:ok, product} = Products.insert(params_for(:product))
      result = result ++ [product: product]
    end

    if tags[:new_product_params] do
      new_product_params = params_for(:product)
      result = result ++ [new_product_params: new_product_params]
    end

    if tags[:create_products] do
      {:ok, product_01} = params_for(:product) |> Products.insert()
      {:ok, product_02} = params_for(:product) |> Products.insert()
      result = result ++ [products: [product_01, product_02]]
    end

    {:ok, result}
  end

  setup_all do
    drop_contents()
    {:ok, dummy: :dumb}
  end

  defp drop_contents do
    # IO.puts "Drop redis content"
    Exredis.Api.keys("*")
    |> Enum.each(&Exredis.Api.del(&1))

    # IO.puts "Drop Product collection content"
    Repo.delete_all(Product)

    # IO.puts "Drop elastic content"
    Elasticsearch.drop()
  end
end
