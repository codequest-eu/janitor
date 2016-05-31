#leaving it for testing purposes

defmodule Janitor.TestController do
  use Janitor.Web, :controller

  def index(conn, _params) do
    text conn, "Success!"
  end
end
