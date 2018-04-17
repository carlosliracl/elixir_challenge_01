defmodule ChallengePhxWeb.PageController do
  use ChallengePhxWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
