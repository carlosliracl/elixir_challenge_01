defmodule Website.Repo do
  use Ecto.Repo, otp_app: :website, adapter: Mongo.Ecto
  use Scrivener, page_size: 4

  defmodule NewRelic do
    use NewRelixir.Plug.Repo, repo: Website.Repo
  end
  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
