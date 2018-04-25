defmodule ChallengePhxWeb.ProductReportControllerTest do
  use ChallengePhxWeb.ConnCase
  use ChallengePhxWeb.RepoCase

  import Mock

  require IEx

  test "do something", %{conn: conn} do
    with_mock HTTPotion, [get: fn(_url) -> "<html></html>" end] do
      HTTPotion.get("http://example.com")
      assert called HTTPotion.get("http://example.com")
    end
  end
end