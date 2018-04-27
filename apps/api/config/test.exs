use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api, ApiWeb.Endpoint,
  http: [port: 4100],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
# config :api, Api.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "api_test",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox
config :api, Api.Mailer,
  adapter: Swoosh.Adapters.Test