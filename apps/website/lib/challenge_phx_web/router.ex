defmodule WebsiteWeb.Router do
  use WebsiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Website.RequestLogger
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebsiteWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/products", ProductController
    get "/generate_product_report", ProductReportController, :generate_report
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebsiteWeb do
  #   pipe_through :api
  # end
end