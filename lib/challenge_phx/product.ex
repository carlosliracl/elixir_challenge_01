defmodule ChallengePhx.Product do
  use Ecto.Schema
  import Ecto.Changeset
  
  @derive {Poison.Encoder, only: [:id, :sku, :name, :description, :quantity, :price, :ean, :created_at, :updated_at]}

  @primary_key {:id, :binary_id, autogenerate: true}  # the id maps to uuid

  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :float
    field :quantity, :integer
    field :sku, :string
    field :ean, :string

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(product, attrs \\ %{}) do
    product
    |> cast(attrs, [:sku, :name, :description, :quantity, :price, :ean])
    |> validate_required([:sku, :name, :description, :quantity, :price, :ean])
    |> unique_constraint(:sku, name: "sku_1")
    |> validate_format(:sku, ~r/^[A-Za-z0-9-]+$/)
    |> validate_number(:price, greater_than: 0)
    |> validate_length(:ean, min: 8, max: 13)
  end

  def to_list(product) do
    fields = [:id, :sku, :name, :description, :quantity, :price, :ean]
    product
    |> Map.to_list
    |> Enum.filter(&(Enum.member?(fields, elem(&1, 0))))
  end

end
