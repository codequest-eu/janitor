defmodule Janitor.UserView do
  use Janitor.Web, :view

  def render("me.json", %{user: user}) do
    user
    |> Map.take(~W(first_name last_name email))
  end
end
