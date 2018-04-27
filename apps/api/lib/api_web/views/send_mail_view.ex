defmodule ApiWeb.SendMailView do
  use ApiWeb, :view
  def render("index.json", %{message: message}) do
    %{
      message: message
    }
  end
  def render("index.json", %{error: error}) do
    %{
      error: error
    }
  end
end
