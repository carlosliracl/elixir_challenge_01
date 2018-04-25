defmodule ChallengePhx.Products do
  alias ChallengePhx.Repo
  alias ChallengePhx.Product
  alias ChallengePhx.ProductCache
  require IEx

  @file_path "/opt/apps/challenge_reports/"

  def get(id) do
    case ProductCache.get(id) do cached_product
      when
        is_map( cached_product) -> cached_product
        :undefined -> load_from_db(id)
    end
  end

  defp load_from_db(product_id) do
    try do
      case Repo.get(Product, product_id) do product
        when
          is_map(product) ->
            ProductCache.store(product)
            product
          _ ->
            :undefined
      end
    rescue _ ->
        :undefined
    end
  end

  def insert(params \\ %{}) do
    changeset = Product.changeset(%Product{}, params)
    case Repo.insert changeset do
      {:ok, product} ->
        ProductCache.store(product)
        {:ok, product}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update(product, params \\ %{}) do
    changeset = Product.changeset(product, params)

    case Repo.update changeset do
      {:ok, product} ->
        ProductCache.store(product)
        {:ok, product}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete(product) do
    case Repo.delete(product) do
      {:ok, product} ->
        ProductCache.delete(product.id)
        {:ok, product}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

 
end
