defmodule WebsiteWeb.ProductReportController do
  use WebsiteWeb, :controller
  require IEx

  def generate_report(conn, _params) do

    response = Task.async(Website.Jobs.CreateReport, :perform, [])
    # |> Task.await()

    # Supervisor.start_link([Website.Jobs.CreateReport], [strategy: :one_for_one])

    # {:ok, encoded} = Poison.encode(%{class:  "ManualQueue.Jobs.CreateReport", args: [], created_at: :os.system_time})
    # Exredis.Api.sadd("manual:queue", encoded)
    
    # {:ok, ack} = Exq.enqueue_in(Exq, "default", 10, "QueueEater.Jobs.ProductReportTask", [])

    conn
    |> put_flash(:info, "O relatório será enviado por e-mail assim que estiver pronto")
    |> redirect(to: product_path(conn, :index))
  end
end