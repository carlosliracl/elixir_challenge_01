defmodule ChallengePhx.Product do
  use Ecto.Schema
  import Ecto.Changeset
  # @derive {Poison.Encoder, exclude: [:__meta__]}
  @derive {Poison.Encoder, only: [:id, :sku, :name, :description, :quantity, :price, :created_at, :updated_at]}

  @primary_key {:id, :binary_id, autogenerate: true}  # the id maps to uuid

  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :float
    field :quantity, :integer
    field :sku, :string

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(product, attrs \\ %{}) do
    product
    |> cast(attrs, [:sku, :name, :description, :quantity, :price])
    |> validate_required([:sku, :name, :description, :quantity, :price])
    |> unique_constraint(:sku, name: "sku_1")
  end
end
