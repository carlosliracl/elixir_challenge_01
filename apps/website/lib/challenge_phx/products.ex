defmodule Website.Models.Products do
  alias Website.Repo
  alias Website.Models.Product
  alias Website.Cache.ProductCache
  require IEx

  def get(id) do
    case ProductCache.get(id) do cached_product
      when
        is_map(cached_product) -> cached_product
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

  def search_products(nil), do: search_products("")
  def search_products(""), do: Repo.all(Product)

  def search_products(search_param) do
    case search_param == nil do
      _ -> ProductCache.search(search_param)
    end
  end

end
