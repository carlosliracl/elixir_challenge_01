defmodule ChallengePhx.Job.ProductReportTaskTest do
  use ChallengePhxWeb.ConnCase
  use ChallengePhxWeb.RepoCase

  import ChallengePhx.Factory

  alias ChallengePhx.Jobs.CreateReport

  require IEx

  setup context do
    if context[:products] do
      report_header = "sku;name;description;price;quantity;ean\n"

      report_data =
        context[:products]
        |> Enum.map(
          &"#{&1.sku};#{&1.name};#{&1.description};#{&1.price};#{&1.quantity};#{&1.ean}"
        )
        |> Enum.join("\n")

      [header: report_header, data: report_data]
    else
      context
    end
  end

  @tag :insert_one_product
  test "the content of a report line", %{product: product} do
    expected_line =
      "#{product.sku};#{product.name};#{product.description};#{product.price};#{
        product.quantity
      };#{product.ean}"

    assert expected_line == CreateReport.report_line(product)
  end

  @tag :drop_products
  @tag :create_products
  test "the report data", context do
    assert context.data == CreateReport.report_data()
  end

  @tag :drop_products
  @tag :create_products
  test "the report file content", context do
    {:ok, file_name} = CreateReport.build_report()
    assert File.exists?(file_name)
    assert {:ok, context.header <> context.data} == File.read(file_name)
  end
end
