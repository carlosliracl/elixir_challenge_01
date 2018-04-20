defmodule ChallengePhx.Products do
  alias ChallengePhx.Repo
  alias ChallengePhx.Product
  alias ChallengePhx.ProductCache
  
  def get(product_id) do
    try do
      case Repo.get(Product, product_id) do product
        when
          is_map(product) -> product
          _ -> :undefined
      end
    rescue _ ->
        :undefined
    end
  end
end
