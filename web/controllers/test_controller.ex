defmodule Janitor.TestController do
  use Janitor.Web, :controller
  use Timex

  def index(conn, _params) do
    text conn, "Success!"
  end
end
