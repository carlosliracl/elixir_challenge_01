defmodule ChallengePhx.Jobs.CreateReport do

  require IEx
  require Logger
  import Ecto.Query
  alias ChallengePhx.Repo
  alias ChallengePhx.Product

  @file_path "/opt/apps/challenge_reports/"

  def perform do
    try do
      __MODULE__.build_report()
      :ok
    rescue e ->
      Logger.error(e)
      :error
    end
  end

  def report_header do
    "sku;name;description;price;quantity;ean\n"
  end

  def report_data do
    products = Repo.all(Product)
    products
    |> Enum.map(&(report_line(&1)))
    |> Enum.join("\n")
  end


  def report_line(product) do
    product.sku
    <> ";" <> product.name
    <> ";" <> product.description
    <> ";" <> to_string(product.price)
    <> ";" <> to_string(product.quantity)
    <> ";" <> product.ean
  end

  def build_report do
    report_file_name = gen_report_file_name()
    report_content = report_header() <> report_data()
    case File.write(report_file_name, report_content) do
      {:error, _} ->
        :error
      :ok ->

        # queue("ManualQueue.Jobs.SendMail", ["carlosliracl@gmail.com", "Relatorio Gerado #{DateTime.to_string DateTime.utc_now}", "Vide arquivo em anexo", report_content])
        # {:ok, report_file_name}
        
        send_mail(report_file_name)
    end
  end

  def send_mail(filename) do
    form = {
      :multipart, [
        {"name", "Carlos Lira"},
        {"to", "carlosliracl@gmail.com"},
        {"subject", "Relatorio Gerado #{DateTime.to_string DateTime.utc_now}"},
        {"body", "Em anexo"},
        # {"upload", filename},
        {
          :file, 
          filename, 
          {"form-data", [
            {:name, "upload"},
            {:filename, Path.basename(filename)}
          ]}, 
          []
        }
      ]
    }


    response = HTTPoison.post("http://localhost:4101/send", form)
    {:ok, filename}
  end

  defp gen_report_file_name do
    @file_path <> "report_#{:os.system_time}.csv"
  end

end