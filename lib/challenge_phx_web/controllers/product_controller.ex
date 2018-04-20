defmodule ChallengePhxWeb.ProductController do
  use ChallengePhxWeb, :controller

  import ChallengePhxWeb.Router.Helpers

  alias ChallengePhx.ProductCache
  alias ChallengePhx.Repo
  alias ChallengePhx.Product
  alias ChallengePhx.Products

  require Logger
  require IEx

  plug :set_product  when action in [:show, :update, :edit, :delete]

  def index(conn, params) do
    search_param = Map.get(params, "q")
    products = search_products search_param
    render(conn, "index.html", products: products, search_param: search_param)
  end

  def show(conn, %{"id" => _id }) do
    # IEx.pry
    product = conn.assigns[:product]
    conn
    |> render("show.html", product: product)
  end

  def new(conn, _params) do
    changeset = Product.changeset(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    %{"product" => product_params } = params
    changeset = Product.changeset(%Product{}, product_params)
    case Repo.insert changeset do
      {:ok, product} ->
        ProductCache.store(product)
        conn
        |> put_flash(:info, "#{product.name} created!")
        |> redirect(to: product_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => _id }) do
    product = conn.assigns[:product]
    changeset = Product.changeset(product)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, params) do
    %{"product" => product_params } = params
    product = conn.assigns[:product]
    changeset = Product.changeset(product, product_params)
      case Repo.update changeset do
        {:ok, product} ->
          ProductCache.store(product)
          conn
          |> put_flash(:info, "#{product.name} updated!")
          |> redirect(to: product_path(conn, :index))
        {:error, changeset} ->
          render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, params) do
    product_to_remove = conn.assigns[:product]

    case Repo.delete(product_to_remove) do
      {:ok, product} ->
        ProductCache.delete(product.id)
        conn
        |> put_flash(:info, "Product #{product.name} destroyed")
        |> redirect(to: product_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Product destroy failed")
        |> render("show.html", changeset: changeset)
    end
  end

  defp set_product(conn, _attrs) do
    %{"id" => id } = conn.params

    case ProductCache.get(id) do cached_product
      when
        is_map( cached_product) -> assign(conn, :product, cached_product)
        :undefined ->
          case Products.get(id)  do product
            when
              is_map(product) ->
                ProductCache.store(product)
                assign(conn, :product, product)
              _ ->
                conn
                |> put_flash(:error, "Product #{id} not found.")
                |> redirect(to: product_path(conn, :index))
            end
    end
  end


  defp search_products(search_param \\ "") do
    case search_param != nil and search_param |> String.trim |> String.length  do
      0 -> Repo.all(Product)
      false -> Repo.all(Product)
      _ -> ProductCache.search(search_param)
    end
  end
end