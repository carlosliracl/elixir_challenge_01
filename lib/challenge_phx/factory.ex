defmodule ChallengePhx.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: ChallengePhx.Repo

  def product_factory do
    %ChallengePhx.Product{
      sku: sequence(:sku, &"SKU-AA-00#{&1}"),
      name: Faker.Commerce.product_name,
      description: Faker.Lorem.paragraph,
      price: Faker.Commerce.price,
      quantity: Faker.random_between(1, 100),
      ean: sequence(:sku, &"EAN999888#{&1}"),
    }
  end
end