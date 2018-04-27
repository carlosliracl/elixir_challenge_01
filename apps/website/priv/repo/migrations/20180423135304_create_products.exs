defmodule Website.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do

    create unique_index(:products, [:sku], name: "sku_1")
    # execute touch: "my_table", data: true, index: true
  end
end
