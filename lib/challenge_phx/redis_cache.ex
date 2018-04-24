defmodule ChallengePhx.RedisCache do
  import Exredis
  import Exredis.Api
  require IEx

  def get(struct, id) do
    {:ok, client} = Exredis.start_link
    result = hget(client, struct_field(struct) , id)
    client |> stop

    case result do
        :undefined -> :undefined
        _ -> Poison.decode! result, as: struct.__struct__
    end
  end

  def store(model) do
    {:ok, encoded} = Poison.encode(model)
    {:ok, client} = Exredis.start_link
    client |> hset(model_field(model), model.id, encoded)
    client |> stop
  end

  def delete(struct, id) do
    {:ok, client} = Exredis.start_link
    client |> hdel(struct_field(struct), id)
    client |> stop
  end

  def all(struct) do
    {:ok, client} = Exredis.start_link
    result = hgetall(client, struct_field(struct))
    client |> stop

    result
    |> Map.values
    |> Enum.map(&(Poison.decode!(&1, as: struct.__struct__) ))
  end

  defp model_field model do
    "#{Mix.env}_#{elem(model.__meta__.source, 1)}"
  end
  defp struct_field struct do
    "#{Mix.env}_#{elem(struct.__struct__.__meta__.source, 1)}"
  end
end