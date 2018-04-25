defmodule ChallengePhx.Jobs.ProductReportTask do
  use Task
  alias ChallengePhx.Repo
  alias ChallengePhx.Product
  require IEx

  @file_path "/opt/apps/challenge_reports/"
  # @file_path "/tmp/"

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  # used with exq
  def perform do
    __MODULE__.build_report()
  end

  # used with Supervisor
  def run(arg) do
    __MODULE__.build_report()
  end

  def report_data do
    Repo.all(Product)
    |> Enum.map(&(
      report_line(&1)
    ))
    |> Enum.join("\n")
  end

  def report_line(product) do
    product.id
    <> ";" <> product.sku
    <> ";" <> product.name
    <> ";" <> product.description
    <> ";" <> to_string(product.price)
    <> ";" <> to_string(product.quantity)
    <> ";" <> product.ean
  end

  def build_report do
    # if Enum.random([true,true,true,true, false]) do
    #   raise ArgumentError, "just to force an error"
    # end

    report_file_name = gen_report_file_name()
    case File.write(report_file_name, report_data()) do
      {:error, _} ->
        :error
      :ok ->
        {:ok, report_file_name}
    end
  end

  defp gen_report_file_name do
    @file_path <> "report_#{Enum.random(1..100)}_#{DateTime.utc_now |> DateTime.to_unix}.csv"
  end
end