require IEx
defmodule Janitor.TestController do
  use Janitor.Web, :controller
  use Timex

  alias Janitor.User

  def index(conn, _params) do
    text conn, "Success!"
  end




end
