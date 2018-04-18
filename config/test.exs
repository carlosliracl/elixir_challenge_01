use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :challenge_phx, ChallengePhxWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
# config :challenge_phx, ChallengePhx.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "challenge_phx_test",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox


config :challenge_phx, ChallengePhx.Repo,
  database: "challenge_test",
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