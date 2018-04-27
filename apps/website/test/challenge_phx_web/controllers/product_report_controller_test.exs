defmodule WebsiteWeb.ProductReportControllerTest do
  use WebsiteWeb.ConnCase
  use WebsiteWeb.RepoCase

  alias Website.Jobs.CreateReport
  alias Website.Helpers.PathHelper

  import Mock

  require IEx

  setup tags do
    if tags[:remove_report_file], do: File.rm("/tmp/report.csv")
    :ok
  end

  @tag :remove_report_file
  test "GET /generate_product_report builds report file", %{conn: conn} do
    with_mocks([
      {HTTPoison, [], [post: fn _url, _ -> :ok end]},
      {PathHelper, [], [gen_report_file_name: fn -> "/tmp/report.csv" end]}
    ]) do


      response = conn |> get("/generate_product_report")

      # HACK: without the sleep the test fails when run `mix test` but succeed when only this file is tested
      :timer.sleep 1

      assert response.status == 302
      assert File.exists?("/tmp/report.csv")
    end
  end
end
