defmodule ChallengePhxWeb.ProductReportControllerTest do
  use ChallengePhxWeb.ConnCase
  use ChallengePhxWeb.RepoCase

  alias ChallengePhx.Jobs.CreateReport
  alias ChallengePhx.Helpers.PathHelper

  import Mock
  
  require IEx

  setup do
    File.rm("/tmp/report.csv")
    :ok
  end

  test "GET /generate_product_report builds report file", %{conn: conn} do
    with_mocks([
      {HTTPoison, [], [post: fn _url, _ -> :ok end]},
      {PathHelper, [], [gen_report_file_name: fn -> "/tmp/report.csv" end]}
    ]) do
      response = conn |> get("/generate_product_report")

      assert response.status == 302
      assert File.exists?("/tmp/report.csv")
    end
  end
end
