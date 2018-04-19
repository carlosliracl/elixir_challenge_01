defmodule ChallengePhx.Logger do
  import Plug.Conn
  require Logger
  import Plug.Conn
  import IEx

  # def debug(content, opts \\ []) do
  #   do_log :debug, content, opts
  # end

  # def error(content, opts \\ []) do
  #   do_log :error, content, opts
  # end
  
  # def info(content, opts \\ []) do
  #   do_log :info, content, opts
  # end
  # defp do_log(level, content, opts \\ []) do
  #   IO.inspect( extra_params(opts))

  # defp extra_params(opts \\ []) do
  #   # [[key: "value"] | opts]
  #   # opts ++ [testando: "value"]
  #   opts
  # end

  def formatter(event) do
    event
    # |> Map.put(:level, level_name_to_syslog_level(event[:level]))
    |> Map.put(:beam_pid, event[:pid])
    |> Map.delete(:pid)
    |> Map.delete(:file)
    |> Map.delete(:line)
  end
#   def level_name_to_syslog_level(level_name, default_level \\ 6) do
#     case level_name do
#        :error -> 3
#        :warn -> 4
#        :info -> 6
#        :debug -> 7
#        level when is_integer(level) -> level
#        _ -> default_level
#     end
#  end

  def log_events_before(conn, _) do
    conn_to_log = conn
    |> Map.delete(:before_send)
    |> Map.delete(:adapter)
    |> Map.delete(:private)
    |> Map.delete(:secret_key_base)
    |> Map.delete(:resp_body)
    |> Map.delete(:resp_headers)
    |> Map.delete(:resp_cookies)
    
    Logger.debug inspect("teste logs")

    conn
  end

  def call(conn, level) do

    IEx.pry
    Plug.Conn.register_before_send(conn, fn(conn) ->
      status = conn.status
      Logger.metadata([
        status: status,
        request_path: conn.request_path,
        method: conn.method,
        query_string: conn.query_string
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