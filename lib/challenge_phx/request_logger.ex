defmodule ChallengePhx.RequestLogger do
  import Plug.Conn
  require Logger

  def init(opts) do
    Keyword.get(opts, :log, :info)
  end

  def call(conn, level) do

    begin_time = :os.system_time(:millisecond)

    Plug.Conn.register_before_send(conn, fn(conn) ->
      # IEx.pry
      end_time = :os.system_time(:millisecond)

      status = conn.status
      Logger.metadata([
        status: status,
        request_path: conn.request_path,
        method: conn.method,
        query_string: conn.query_string,
        params: conn.params,
        duration: (end_time - begin_time)
      ])
      Logger.log(level, fn ->
        metadata = Logger.metadata
        duration = Keyword.get(metadata, :duration, -1)
        "#{conn.method} #{conn.request_path} :: #{status} in #{duration}ms"
      end)

      conn
    end)
  end
end