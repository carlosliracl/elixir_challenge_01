defmodule ChallengePhx.Helpers.PathHelper do
  @file_path "/opt/apps/challenge_reports/"

  def gen_report_file_name do
    @file_path <> "report_#{:os.system_time()}.csv"
  end
end
