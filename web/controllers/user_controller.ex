defmodule Janitor.UserController do
  use Janitor.Web, :controller

  def me(conn, _params) do
    render conn, :me, user: conn.assigns.current_user
  end
end
