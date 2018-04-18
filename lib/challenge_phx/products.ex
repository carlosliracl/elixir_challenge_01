defmodule ChallengePhx.Products do
  alias ChallengePhx.Repo
  alias ChallengePhx.Product

  import  Logger
  def get(product_id) do
    Logger.debug("Loading Product##{product_id} from mongodb")
    try do
      case Repo.get(Product, product_id) do product
        when
          is_map(product) -> product
          _ -> :error
            # conn
            # |> put_flash(:error, "Product #{id} not found.")
            # |> redirect(to: product_path(conn, :index))
      end
    rescue _ ->
        # conn
        # |> put_flash(:error, "Product #{id} not found.")
        # |> redirect(to: product_path(conn, :index))
        :error
    end
  end


  def boot_cache do
    Repo.all(Product)
    |> ProductCache.store
    :ok
  end
end
