defmodule ChallengePhx.Cache.ProductCache do
  require IEx

  alias ChallengePhx.Models.Product
  alias ChallengePhx.Cache.Redis
  alias ChallengePhx.Cache.Elasticsearch
  require Logger

  def delete(product_id) do
    Redis.delete(Product, product_id)
    Elasticsearch.delete(Product, product_id)
  end

  def store(product) do
    Redis.store(product)
    Elasticsearch.store(product)
  end

  def get(product_id) do
    Redis.get(Product, product_id)
  end

  def search(param \\ "") do
    Elasticsearch.search(Product, param)
  end
end
