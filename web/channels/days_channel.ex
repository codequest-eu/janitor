defmodule Janitor.DaysChannel do
  use Janitor.Web, :channel
  alias Janitor.Repo
  alias Janitor.User
  alias Janitor.Day
  alias Janitor.DaysView
  import Janitor.DaysQueryHelpers

  def join("days", params, socket) do
    case get_user_id(params) do
      {:ok, user_id} -> {:ok, assign(socket, :user_id, user_id)}
      {:error, _} -> {:error, %{error: "Unauthorized"}}
    end
  end

  def handle_in(event, params, socket) do
    user_id  = socket.assigns[:user_id]
    case user_id do
      nil -> {:reply, {:error, %{errors: "Unauthorized"}}, socket}
      _ ->
        user = Repo.get(User, user_id)
        handle_in(event, params, user, socket)
    end
  end

  defp handle_in("get:days", params, user, socket) do
    days = Repo.all(from_month())
    payload = %{
      days: DaysView.render("days.json", days: days),
      message: "Days Loaded"
    }
    {:reply, {:ok, payload}, socket}
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
    case params["token"] |> verify_token do
      {:ok, claims} -> {:ok, claims.user_id}
      {:error, _} -> {:error, nil}
    end
  end

  defp verify_token(token) do
    case token do
      nil -> {:error, nil}
      _ -> token |> JsonWebToken.verify(%{key: System.get_env("JWT_SECRET")})
    end
  end

  defp day_changes(day_id, params) do
    day = Repo.get(Day, String.to_integer(day_id))
    change_params = Map.take(params, [:working, :user_id])
    Day.changeset(day, change_params)
  end
end
