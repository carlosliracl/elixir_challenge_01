defmodule Website.LoggerFormatter do
  def formatter(event) do
    event
    # |> Map.put(:level, level_name_to_syslog_level(event[:level]))
    |> Map.put(:beam_pid, event[:pid])
    |> Map.delete(:pid)
    |> Map.delete(:file)
    |> Map.delete(:line)
  end
end