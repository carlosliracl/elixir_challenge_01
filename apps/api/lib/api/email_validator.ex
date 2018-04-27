defmodule Api.Validator do
  

  def validate_email(nil),  do: false
  def validate_email(""),  do: false

  def validate_email(email) when is_binary(email) do
    case Regex.run(~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/, email) do
      nil ->
        {:error, "Invalid email"}
      [email] ->
        try do
          Regex.run(~r/(\w+)@([\w.]+)/, email) |> validate_email
        rescue
          _ -> {:error, "Invalid email"}
        end
    end
  end


  def validate_required_string(nil), do: false

  def validate_required_string(string), do: string |> String.trim |> String.length > 0

end