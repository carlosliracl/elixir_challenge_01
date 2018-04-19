defmodule ChallengePhx.ProductCache do
  import Exredis
  import Exredis.Api
  import Tirexs.HTTP
  import Tirexs.Search
  
  # require Elistix

  require IEx

  alias ChallengePhx.Product
  require Logger
  
  def delete(product_id) do
    delete_redis product_id
    delete_elasticsearch product_id
  end

  def store(product) do
    store_elasticsearch product
    store_redis product
  end

  def get(product_id) do
    {:ok, client} = Exredis.start_link
    result = hget(client, "products", product_id)
    client |> stop

    case result do
        :undefined -> :error
        _ -> Poison.decode! result, as: %Product{}
    end

  end

  def all do
    {:ok, client} = Exredis.start_link
    result = hgetall(client, "products")
    client |> stop

    result
    |> Map.values
    |> Enum.map(fn(x) -> Poison.decode!(x, as: %Product{})  end)

  end


  def search(param \\ "") do
    query = search [index: "challenge"] do
      size 200
      query do
        # multi_match  param, ["sku", "name", "description"]
        query_string "*#{param}*"
      end
    end
    # IO.inspect(query)
    result = Tirexs.Query.create_resource(query)
    # IO.inspect(result)
    hits = elem(result, 2).hits.hits
    hits
    |> Enum.map(fn(el) -> el._source  end)
  end
#  private methods


  # redis 
  defp store_redis(product) do
    {:ok, encoded} = Poison.encode(product)
    {:ok, client} = Exredis.start_link
    client |> hset("products", product.id, encoded)
    client |> stop
  end
  defp delete_redis(product_id) do
    {:ok, client} = Exredis.start_link
    client |> hdel("products", product_id)
    client |> stop
  end

  #elasticsearch
  defp store_elasticsearch(product) do
    {:ok, encoded} = Poison.encode(product)
    result = put("/challenge/products/#{product.id}", Product.to_list product)
  end

  defp delete_elasticsearch(product_id) do
    Tirexs.HTTP.delete("/challenge/products/#{product_id}")
  end

end