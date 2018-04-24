# Application.ensure_all_started(:hound)
{:ok, _} = Application.ensure_all_started(:wallaby)
{:ok, _} = Application.ensure_all_started(:ex_machina)

Application.put_env(:wallaby, :base_url, ChallengePhxWeb.Endpoint.url)
ExUnit.start(trace: true)

# Ecto.Adapters.SQL.Sandbox.mode(ChallengePhx.Repo, :manual)
