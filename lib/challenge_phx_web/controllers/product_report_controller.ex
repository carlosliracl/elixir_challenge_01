defmodule ChallengePhxWeb.ProductReportController do
  use ChallengePhxWeb, :controller
  require IEx

  def generate_report(conn, _params) do

    # Supervisor.start_link([ChallengePhx.Jobs.ProductReportTask], [strategy: :one_for_one])

    {:ok, ack} = Exq.enqueue_in(Exq, "default", 10, "QueueEater.Jobs.ProductReportTask", [])

    conn
    |> put_flash(:info, "O relatório será enviado por e-mail assim que estiver pronto")
    |> redirect(to: product_path(conn, :index))
  end
end