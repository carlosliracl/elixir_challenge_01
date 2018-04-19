defmodule ChallengePhx.RequestLogger do
  import Plug.Conn
  import IEx
  require Logger

  def init(opts) do
    Keyword.get(opts, :log, :info)
  end

  def call(conn, level) do
    Plug.Conn.register_before_send(conn, fn(conn) ->

      # IEx.pry

      status = conn.status
      Logger.metadata([
        status: status,
        request_path: conn.request_path,
        method: conn.method,
        query_string: conn.query_string,
        params: conn.params,
      ])
      Logger.log(level, fn ->
        metadata = Logger.metadata
        duration = Keyword.get(metadata, :duration, -1)
        "#{conn.method} #{conn.request_path} :: #{status} in #{duration}ms EQEQWRQWER"
      end)

      conn
    end)
  end
end