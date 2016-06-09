defmodule Janitor.UserController do
  use Janitor.Web, :controller
  alias Janitor.User

  def me(conn, _params) do
    render conn, "me.json", user: conn.assigns.current_user
  end
end
