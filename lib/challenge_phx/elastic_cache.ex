defmodule ChallengePhx.ElasticCache do
  import Tirexs.HTTP
  import Tirexs.Search
  require IEx

  def store(model) do
    # {:ok, encoded} = Poison.encode(model)
    result = put("/challenge/#{model_field(model)}/#{model.id}", model.__struct__.to_list model)
  end

  def delete(struct, id) do
    delete("/challenge/#{struct_field(struct)}/#{id}")
  end

  def search(struct, param \\ "") do
    query = Tirexs.Search.search [index: "challenge"] do
      size 200
      query do
        # multi_match  param, ["sku", "name", "description"]
        query_string "*#{param}*"
      end
    end
    # IO.inspect(query)
    result = Tirexs.Query.create_resource(query)
    # IO.inspect(result)
    if elem(result, 0) == :error do
      []
    else
      hits = elem(result, 2).hits.hits
      hits
      |> Enum.map(fn(el) -> el._source  end)
    end
    
  end

  defp model_field model do
    elem(model.__meta__.source, 1)
  end
  defp struct_field struct do
    elem(struct.__struct__.__meta__.source, 1)
  end
end