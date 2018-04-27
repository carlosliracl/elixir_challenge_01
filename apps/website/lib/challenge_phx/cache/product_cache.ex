defmodule Website.Cache.ProductCache do
  require IEx

  alias Website.Models.Product
  alias Website.Cache.Redis
  alias Website.Cache.Elasticsearch
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
