defmodule ChallengePhx.ProductCache do
  require IEx

  alias ChallengePhx.Product
  alias ChallengePhx.RedisCache
  alias ChallengePhx.ElasticCache
  require Logger

  def delete(product_id) do
    RedisCache.delete Product, product_id
    ElasticCache.delete Product, product_id
  end

  def store(product) do
    RedisCache.store product
    ElasticCache.store product
  end

  def get(product_id) do
    RedisCache.get Product, product_id
  end

  def search(param \\ "") do
    ElasticCache.search Product, param
  end
end