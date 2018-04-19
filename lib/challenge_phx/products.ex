defmodule ChallengePhx.Products do
  alias ChallengePhx.Repo
  alias ChallengePhx.Product
  alias ChallengePhx.ProductCache
  alias ChallengePhx.Logger
  
  def get(product_id) do
    try do
      case Repo.get(Product, product_id) do product
        when
          is_map(product) -> product
          _ -> :error
      end
    rescue _ ->
        :error
    end
  end

  def boot_cache do
    Repo.all(Product)
    |> ProductCache.store
    :ok
  end
end
