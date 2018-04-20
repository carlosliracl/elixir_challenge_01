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
  ChallengePhx.Repo.insert!(%ChallengePhx.Product{
    sku: Faker.String.base64,
    name: Faker.Commerce.product_name,
    description: Faker.Commerce.department,
    quantity: :rand.uniform(99),
    price: Faker.Commerce.price,
  })
end

## feed elasticsearch
# alias ChallengePhx.Repo
# alias ChallengePhx.Product
# alias ChallengePhx.ProductCache
Repo.all(Product) |> Enum.each(fn(product) -> ProductCache.store product  end)