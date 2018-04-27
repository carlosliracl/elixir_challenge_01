defmodule Website.Mixfile do
  use Mix.Project

  def project do
    [
      app: :website,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Website.Application, []},
      # extra_applications: [:logger, :runtime_tools, :mongodb_ecto, :logstash_json] 
      extra_applications: app_list(Mix.env())
      # extra_applications: app_list() 
    ]
  end

  def app_list do
    [:logger, :runtime_tools, :mongodb_ecto, :logstash_json]
  end

  def app_list(:dev), do: [:exq_ui | app_list()]
  # def app_list(:test), do: [:hound | app_list()]
  def app_list(_), do: app_list()

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:mongodb_ecto, github: "michalmuskala/mongodb_ecto"},
      # ecto pagination
      {:scrivener_ecto, "~> 1.0"},
      # code style
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false},
      {:exredis, ">= 0.2.4"},
      # elasticsearch
      {:tirexs, "~> 0.8"},
      {:logstash_json, github: "svetob/logstash-json"},
      {:faker, "~> 0.10"},
      {:ex_guard, "~> 1.3", only: :dev},
      {:wallaby, "~> 0.20.0", [runtime: false, only: :test]},
      {:ex_machina, "~> 2.2"},
      {:exq, "~> 0.10.1", only: [:dev, :test]},
      {:exq_ui, "~> 0.9.0", only: [:dev, :test]},
      {:mock, "~> 0.3.0", only: :test},
      {:httpoison, "~> 1.0", override: true},
      {:distillery, "~> 1.5", runtime: false},
      {:ex_debug_toolbar, "~> 0.4.0"},
      {:postgrex, "~> 0.13.0"},
      {:new_relixir, "~> 0.4"},
      {:api, in_umbrella: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["assets.compile --quiet", "ecto.drop", "ecto.create", "ecto.migrate", "test"],
      "assets.compile": &compile_assets/1
    ]
  end

  defp compile_assets(_) do
    Mix.shell().cmd("assets/node_modules/brunch/bin/brunch build assets/")
  end
end
