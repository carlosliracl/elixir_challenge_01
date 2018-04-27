defmodule Api.SendMail do
  @moduledoc false

  # use Ecto.Repo, otp_app: :api
  alias Api.Mailer
  import Api.Validator
  import Swoosh.Email
  require IEx

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def send(mail)  do
    # Task.start(fn -> 
      Mailer.deliver(mail) 
    # end)
  end

 

  def build(%{name: name, to: to, subject: subject, body: body, upload: upload}) do
    new()
    |> add_to(name, to)
    |> add_from()
    |> add_subject(subject)
    |> add_body(body)
    |> add_attachment(upload)
  end

  def build(%{name: name, to: to, subject: subject, body: body}) do
    new()
    |> add_to(name, to)
    |> add_from()
    |> add_subject(subject)
    |> add_body(body)
  end

  def add_to(email, name, to) do
    unless validate_required_string(name), do: raise ArgumentError, "the 'name' param looks invalid"
    unless validate_email(to), do: raise ArgumentError, "the 'to' param looks invalid"

    email |> to({name, to})
  end

  def add_from(email) do
    email |> from({"Challenge Phx", "challenge@phx.com"})
  end

  def add_body(email, body) do
    unless validate_required_string(body), do: raise ArgumentError, "the 'body' param looks invalid"
    email |> html_body(body) |> text_body(body)
  end

  def add_subject(email, subject) do
    unless validate_required_string(subject), do: raise ArgumentError, "the 'subject' param looks invalid"
    email |> subject(subject)
  end

  def add_attachment(email, nil) do
    email
  end
  def add_attachment(email, upload) do
    email |> attachment(upload)
  end
end
