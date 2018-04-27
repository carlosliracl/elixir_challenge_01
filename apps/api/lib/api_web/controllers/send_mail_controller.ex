defmodule ApiWeb.SendMailController do
  use ApiWeb, :controller
  alias Api.SendMail
  require IEx

  def send(conn, params) do
    try do
      Api.SendMail.build(%{
        name: params["name"],
        to: params["to"],
        subject: params["subject"],
        body: params["body"],
        upload: upload_file(params["upload"])
      })
      |> Api.SendMail.send

      render conn, "index.json", message: "email enviado"

    rescue
      e in ArgumentError ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("index.json", error: e.message)
    end
  end

  def upload_file(nil), do: nil
  def upload_file(upload) when is_map(upload), do: upload
  
  def upload_file(upload) when is_binary(upload) do
    %Plug.Upload{path: upload, filename: Path.basename(upload)}
  end
end
