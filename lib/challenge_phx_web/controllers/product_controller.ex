defmodule ChallengePhxWeb.ProductController do
  use ChallengePhxWeb, :controller

  import ChallengePhxWeb.Router.Helpers
  
  alias ChallengePhx.Repo
  alias ChallengePhx.Product

  require Logger
  require IEx

  plug :set_product  when action in [:show, :update, :edit, :delete]

  def index(conn, _params) do
    products = Repo.all(Product)
    render(conn, "index.html", products: products)

  end

  def show(conn, %{"id" => _id }) do
    product = conn.assigns[:product]

    conn
    |> render("show.html", product: product)
  end

  def new(conn, params) do
    changeset = Product.changeset(%Product{})
    Logger.debug ("Changeset:  #{inspect(changeset)}")
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    %{"product" => product_params } = params
    # Logger.debug ("Create params:  #{inspect(product_params)}")
       
    changeset = Product.changeset(%Product{}, product_params)

    Logger.debug ("Create product:  #{inspect(changeset)}")
    
    case Repo.insert changeset do
      {:ok, product} ->
        Logger.debug ("Create ok:  #{inspect(product)}")
        conn
        |> put_flash(:info, "#{product.name} created!")
        |> redirect(to: product_path(conn, :index))
      {:error, changeset} ->
        Logger.debug ("Create error:  #{inspect(changeset)}")
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
    
    Logger.debug ("Create params:  #{inspect(product_params)}")
       
    changeset = Product.changeset(product, product_params)
    Logger.debug ("Create product:  #{inspect(changeset)}")
      
      case Repo.update changeset do
        {:ok, product} ->
          Logger.debug ("Create ok:  #{inspect(product)}")
            conn
            |> put_flash(:info, "#{product.name} updated!")
            |> redirect(to: product_path(conn, :index))
        {:error, changeset} ->
            Logger.debug ("Create error:  #{inspect(changeset)}")
            render(conn, "new.html", changeset: changeset)

    end
      redirect( conn, to:  product_path(conn, :index))
  end

  def delete(conn, params) do
    Logger.debug ("Destroy params:  #{inspect(params)}")
    Logger.debug ("Destroy conn.params:  #{inspect(conn.params)}")

    product_to_remove = conn.assigns[:product]

    case Repo.delete(product_to_remove) do
      {:ok, product} -> 
        
        Logger.debug("Destroy ok: #{inspect(product)}")
        conn
        |> put_flash(:info, "Product #{product.name} destroyed")
        |> redirect(to: product_path(conn, :index))

      {:error, changeset} ->
        Logger.debug("Destroy error: #{inspect(changeset)}")
        conn 
        |> put_flash(:error, "Product destroy failed")
        |> render("show.html", changeset: changeset)
    end 
  end

  defp set_product(conn, params) do
    %{"id" => id } = conn.params

    Logger.debug ("params -> #{inspect(params)}")
    Logger.debug ("conn.params -> #{inspect(conn.params)}")
    Logger.debug ("inspected id -> #{inspect(id)}")

    try do
      case Repo.get(Product, id) do product
        when 
          is_map(product)-> 
            assign(conn, :product, product)  
          _ -> 
            conn
            |> put_flash(:error, "Product #{id} not found.")
            |> redirect(to: product_path(conn, :index))
      end
    rescue
      _ -> 
        conn
        |> put_flash(:error, "Product #{id} not found.")
        |> redirect(to: product_path(conn, :index))
    end
  end
end