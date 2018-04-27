defmodule Website.Cache.Elasticsearch do
  import Tirexs.HTTP
  import Tirexs.Search
  require IEx

  def store(model) do
    put(
      "/#{Mix.env()}_challenge/#{model_field(model)}/#{model.id}",
      model.__struct__.to_list(model)
    )
  end

  def delete(struct, id) do
    delete("/#{Mix.env()}_challenge/#{struct_field(struct)}/#{id}")
  end

  def search(_struct, param \\ "") do
    query =
      Tirexs.Search.search index: "#{Mix.env()}_challenge" do
        size(200)

        query do
          # multi_match  param, ["sku", "name", "description"]
          query_string("*#{param}*")
        end
      end

    result = Tirexs.Query.create_resource(query)

    if elem(result, 0) == :error do
      []
    else
      hits = elem(result, 2).hits.hits

      hits
      |> Enum.map(fn el -> el._source end)
    end
  end

  def drop do
    Tirexs.HTTP.delete("/#{Mix.env()}_challenge")
  end

  defp model_field(model) do
    elem(model.__meta__.source, 1)
  end

  defp struct_field(struct) do
    elem(struct.__struct__.__meta__.source, 1)
  end
end
