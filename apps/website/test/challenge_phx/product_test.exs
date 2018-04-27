defmodule ProductTest do
  use ExUnit.Case
  alias Website.Models.Product
  alias Website.Repo
  require IEx
  doctest Product

  @valid_attrs %{
    sku: "1231312-123ASFSasdfsd",
    name: "Product Name",
    description: "May your coffee be hot and strong and your week lighter than today",
    quantity: 20,
    price: 9.90,
    ean: "ABCEDFGJIH"
  }

  test "validates a valid product" do
    valid_product =
      %Product{}
      |> Product.changeset(@valid_attrs)

    assert valid_product.valid? == true
    assert {:ok, _} = Repo.insert(valid_product)
  end

  test "validates product without sku" do
    attrs_without_sku = @valid_attrs |> Map.delete(:sku)

    product =
      %Product{}
      |> Product.changeset(attrs_without_sku)

    assert product.valid? == false
    assert product.errors[:sku] |> elem(0) == "can't be blank"
    assert {:error, _} = Repo.insert(product)
  end

  test "validates product with invalid sku" do
    attrs_invalid_sku = @valid_attrs |> Map.put(:sku, "!@#$%*()_=+")

    product_invalid_sku =
      %Product{}
      |> Product.changeset(attrs_invalid_sku)

    assert product_invalid_sku.valid? == false
    assert product_invalid_sku.errors[:sku] |> elem(0) == "has invalid format"
    assert {:error, _} = Repo.insert(product_invalid_sku)
  end

  test "validates product with price lower than 0" do
    attrs_with_price_equal_zero = @valid_attrs |> Map.put(:price, -1)

    product =
      %Product{}
      |> Product.changeset(attrs_with_price_equal_zero)

    assert product.valid? == false
    assert product.errors[:price] |> elem(0) == "must be greater than %{number}"

    validation = product.errors[:price] |> elem(1)
    assert validation[:number] == 0
    assert {:error, _} = Repo.insert(product)
  end

  test "validates product with price equal 0" do
    attrs_with_price_equal_zero = @valid_attrs |> Map.put(:price, 0)

    product =
      %Product{}
      |> Product.changeset(attrs_with_price_equal_zero)

    assert product.valid? == false
    assert product.errors[:price] |> elem(0) == "must be greater than %{number}"

    validation = product.errors[:price] |> elem(1)
    assert validation[:number] == 0
    assert {:error, _} = Repo.insert(product)
  end

  test "validates product without name" do
    attrs_without_name = @valid_attrs |> Map.delete(:name)

    product =
      %Product{}
      |> Product.changeset(attrs_without_name)

    assert product.valid? == false
    assert product.errors[:name] |> elem(0) == "can't be blank"
    assert {:error, _} = Repo.insert(product)
  end

  test "validates product with empty name" do
    attrs_empty_name = @valid_attrs |> Map.put(:name, "")

    product =
      %Product{}
      |> Product.changeset(attrs_empty_name)

    assert product.valid? == false
    assert product.errors[:name] |> elem(0) == "can't be blank"
    assert {:error, _} = Repo.insert(product)
  end

  test "validates product with empty ean" do
    attrs_empty_name = @valid_attrs |> Map.put(:ean, "")

    product =
      %Product{}
      |> Product.changeset(attrs_empty_name)

    assert product.valid? == false
    assert product.errors[:ean] |> elem(0) == "can't be blank"
    assert {:error, _} = Repo.insert(product)
  end

  test "validates product with ean length lower than 8" do
    attrs_empty_name = @valid_attrs |> Map.put(:ean, "1234567")

    product =
      %Product{}
      |> Product.changeset(attrs_empty_name)

    assert product.valid? == false

    assert product.errors[:ean] |> elem(0) == "should be at least %{count} character(s)"

    validation = product.errors[:ean] |> elem(1)
    assert validation[:min] == 8

    assert {:error, _} = Repo.insert(product)
  end

  test "validates product with ean having more than 13 characters" do
    attrs_empty_name = @valid_attrs |> Map.put(:ean, "12345678901234567")

    product =
      %Product{}
      |> Product.changeset(attrs_empty_name)

    assert product.valid? == false

    assert product.errors[:ean] |> elem(0) == "should be at most %{count} character(s)"

    validation = product.errors[:ean] |> elem(1)
    assert validation[:max] == 13

    assert {:error, _} = Repo.insert(product)
  end
end
