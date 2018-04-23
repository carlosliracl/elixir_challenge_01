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
    search_param = params |> Map.get("q", nil)
    products = search_products search_param
    render(conn, "index.html", products: products, search_param: search_param)
  end

  def show(conn, %{"id" => _id }) do
    product = conn.assigns[:product]
    if product != nil do
      conn
      |> render("show.html", product: product)
    else
      conn
    end
  end

  def new(conn, _params) do
    changeset = Product.changeset(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn,  %{"product" => product_params }) do

    case Products.insert product_params do
      {:ok, product} ->
        conn
        |> put_flash(:info, "#{product.name} created!")
        |> redirect(to: product_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
    
  end

  def edit(conn, %{"id" => _id }) do
    product = conn.assigns[:product]
    if product != nil do
      changeset = Product.changeset(product)
      render(conn, "edit.html", changeset: changeset)
    else
      conn
    end
  end

  def update(conn, %{"product" => product_params }) do
    product = conn.assigns[:product]

    case Products.update product, product_params do
      {:ok, product} ->
        conn
        |> put_flash(:info, "#{product.name} updated!")
        |> redirect(to: product_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end

  end

  def delete(conn, _params) do
    product_to_remove = conn.assigns[:product]

    case Products.delete(product_to_remove) do
      {:ok, product} ->
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

    case Products.get(id) do product
      when
        is_map( product) ->
          assign(conn, :product, product)

        :undefined ->
          conn
          |> put_flash(:error, "Product #{id} not found.")
          |> redirect(to: product_path(conn, :index))
    end
  end


  defp search_products(search_param) do
    case search_param == nil do
      # 0 -> Repo.all(Product)
      true -> Repo.all(Product)
      _ -> ProductCache.search(search_param)
    end
  end
end