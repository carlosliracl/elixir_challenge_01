use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :website, WebsiteWeb.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
# config :website, Website.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "challenge_phx_test",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox


config :website, Website.Repo,
  # pool: Mongo.Pool.Poolboy,
  # pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Mongo.Ecto,
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

# config :hound, driver: "phantomjs"
config :wallaby, phantomjs: "/opt/apps/phantomjs-2.1.1-linux-x86_64/bin/phantomjs"

config :exq_ui,
  server: false