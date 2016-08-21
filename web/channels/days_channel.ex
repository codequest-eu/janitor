defmodule Janitor.DaysChannel do 
  use Janitor.Web, :channel
  alias Janitor.Repo
  alias Janitor.User 
  alias Janitor.Day
  alias Janitor.DaysView

  def join("days", _params, socket) do 
    {:ok, socket}
  end 

  def handle_in(event, params, socket) do 
    case get_user_id(params) do 
      {:ok, user_id} -> 
        user = Repo.get(User, user_id)
        handle_in(event, params, user, socket)
      {:error, _} -> 
        {:reply, {:error, %{errors: "Unauthorized"}}, socket}
    end 
  end 

  defp handle_in("update:day:" <> day_id, params, user, socket) do 
    changes = day_changes(day_id, params)
    case Repo.update(changes) do 
      {:ok, day} -> 
        payload = DaysView.render("day.json", day: day)
        broadcast! socket, "updated:day:#{day.id}", payload
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset.errors}}, socket}
    end 
    
  end 

  defp get_user_id(params) do 
    case params[:token] |> JsonWebToken.verify(%{key: System.get_env("JWT_SECRET")}) do
      {:ok, claims} -> {:ok, claims.user_id}
      {:error, _} -> {:error, nil}
    end 
  end 

  defp day_changes(day_id, params) do 
    day = Repo.get(Day, String.to_integer(day_id))
    change_params = Map.take(params, [:working, :user_id])
    Day.changeset(day, change_params)
  end 
end 
