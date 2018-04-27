# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ChallengePhx.Repo.insert!(%ChallengePhx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
for _ <- 1..100 do
  ChallengePhx.Factory.insert(:product)
  |> ChallengePhx.Cache.ProductCache.store
end
