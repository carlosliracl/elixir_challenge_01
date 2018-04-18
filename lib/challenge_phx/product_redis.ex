defmodule ChallengePhx.ProductCache do
  import Exredis
  import Exredis.Api
  import Logger
  alias ChallengePhx.Product

  def delete(product_id) do
    {:ok, client} = Exredis.start_link
    client |> hdel("products", product_id)
    client |> stop
  end

  def store(product) do
    {:ok, encoded} = Poison.encode(product)

    Logger.debug("Encoded Product: #{inspect(encoded)}")

    {:ok, client} = Exredis.start_link
    client |> hset("products", product.id, encoded)
    client |> stop
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

    # list = []
    # result
    # |> Map.values
    # |> Enum.each(fn(x)-> list = [x | list] end)

    result 
    |> Map.values 
    |> Enum.map (fn(x) -> Poison.decode!(x, as: %Product{})  end)

  end

end