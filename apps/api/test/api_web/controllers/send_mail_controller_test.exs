defmodule ApiWeb.SendMailControllerTest do
  use ApiWeb.ConnCase
  import Swoosh.TestAssertions
  alias Api.SendMail

  @name "Carlos Lira"
  @to "carlosliracl@gmail.com"
  @body "corpo"
  @subject "assunto do email"
  @upload  %Plug.Upload{path: "test/fixtures/report.csv", filename: "report.csv"}

  test "POST /send", %{conn: conn} do

    post_params = %{
      :name => @name,
      :to => @to,
      :body => @body,
      :subject => @subject,
      :upload => @upload
    }
    conn = post(conn, "/send", post_params)

    assert json_response(conn, 200) == %{
      "message" => "email enviado",
    }

    assert_email_sent SendMail.build(%{name: @name, to: @to, body: @body, subject: @subject, upload: @upload})
  end

  test "POST /send without name", %{conn: conn} do

    post_params = %{
      # :name => @name,
      :to => @to,
      :body => @body,
      :subject => @subject,
      :upload => @upload
    }
    conn = post(conn, "/send", post_params)

    assert json_response(conn, 422) == %{ "error" => "the 'name' param looks invalid"}
    assert_email_not_sent SendMail.build(%{name: @name, to: @to, body: @body, subject: @subject, upload: @upload})
  end

  test "POST /send without attachment", %{conn: conn} do

    post_params = %{
      :name => @name,
      :to => @to,
      :body => @body,
      :subject => @subject,
    }
    conn = post(conn, "/send", post_params)

    assert json_response(conn, 200) == %{ "message" => "email enviado"}
    assert_email_sent SendMail.build(%{name: @name, to: @to, body: @body, subject: @subject})
  end

  test "POST /send without params", %{conn: conn} do

    conn = post(conn, "/send")

    assert json_response(conn, 422) == %{ "error" => "the 'name' param looks invalid"}
  end

end
