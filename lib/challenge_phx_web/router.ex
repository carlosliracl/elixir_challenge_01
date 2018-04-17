defmodule ChallengePhxWeb.Router do
  use ChallengePhxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChallengePhxWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/home", HomeController, :index
    get "/home/:messenger", HomeController, :show

  end

  # Other scopes may use custom stacks.
  # scope "/api", ChallengePhxWeb do
  #   pipe_through :api
  # end
end
