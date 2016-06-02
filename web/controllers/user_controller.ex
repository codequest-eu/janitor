defmodule Janitor.UserController do
  use Janitor.Web, :controller

  def me(conn, _params) do
    render conn, "me.json", user: conn.assigns[:current_user]
  end
end
