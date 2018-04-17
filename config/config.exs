# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :challenge_phx,
  ecto_repos: [ChallengePhx.Repo]

# Configures the endpoint
config :challenge_phx, ChallengePhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oiKuVWhnwzV9Xve87y32NMo2V3/9HHkoqhNv4U1GeDBghpRWEszUw0ZEBNuNIDs6",
  render_errors: [view: ChallengePhxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ChallengePhx.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
