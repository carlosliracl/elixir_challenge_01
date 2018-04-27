defmodule WebsiteWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  alias Website.Repo
  alias Website.Models.Product
  alias Website.Cache.Elasticsearch
  alias Exredis.Api
  alias Ela
  require IEx

  using do
    quote do
      # Import conveniences for testing with connections
      use Wallaby.DSL
      use Phoenix.ConnTest
      import WebsiteWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint WebsiteWeb.Endpoint
    end
  end

  setup tags do
    # :ok = Ecto.Adapters.SQL.Sandbox.checkout(Website.Repo)
    # unless tags[:async] do
    #   Ecto.Adapters.SQL.Sandbox.mode(Website.Repo, {:shared, self()})
    # end
    {:ok, session} = Wallaby.start_session()
    conn = Phoenix.ConnTest.build_conn()

    {
      :ok,
      conn: conn, session: session
    }
  end

  # setup_all do
  #   IO.puts "Drop redis content"
  #   Exredis.Api.keys("*")
  #   |> Enum.each(&(Exredis.Api.del(&1)))

  #   IO.puts "Drop Product collection content"
  #   Repo.delete_all(Product)

  #   IO.puts "Drop elastic content"
  #   Elasticsearch.drop
  #   {:ok, dummy: :dumb}
  # end
end
