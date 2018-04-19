defmodule ChallengePhxWeb.Router do
  use ChallengePhxWeb, :router
  import ChallengePhx.Logger

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ChallengePhx.RequestLogger
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChallengePhxWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/products", ProductController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChallengePhxWeb do
  #   pipe_through :api
  # end
end