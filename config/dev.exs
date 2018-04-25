use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :challenge_phx, ChallengePhxWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

config :challenge_phx, ChallengePhxWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/challenge_phx_web/views/.*(ex)$},
      ~r{lib/challenge_phx_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
# config :challenge_phx, ChallengePhx.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "challenge_phx_dev",
#   hostname: "localhost",
#   pool_size: 10

config :challenge_phx, ChallengePhx.Repo,
database: "challenge_development",
# username: "mongodb", # remove if unneeded
  # password: "mongosb", # remove if unneeded
  hostname: "localhost"

config :exredis,
  host: "127.0.0.1",
  port: 6379,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity

config :exq,
  name: Exq,
  host: "127.0.0.1",
  port: 6379,
  namespace: "exq",
  # concurrency: :infinite,
  queues: [],
  # poll_timeout: 10,
  # scheduler_poll_timeout: 200,
  scheduler_enable: false,
  # max_retries: 25,
  # shutdown_timeout: 5000
  start_on_application: true


config :exq_ui,
  web_port: 4040,
  web_namespace: "",
  server: true