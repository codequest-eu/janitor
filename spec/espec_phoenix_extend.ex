defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias Janitor.Repo
    end
  end

  def controller do
    quote do
      alias Janitor.Repo
      import Janitor.Router.Helpers
    end
  end

  def request do
    quote do
      alias Janitor.Repo
      import Janitor.Router.Helpers
    end
  end

  def view do
    quote do
      import Janitor.Router.Helpers
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
