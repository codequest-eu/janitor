defmodule Janitor.TaskController do
  use Janitor.Web, :controller

  alias Janitor.{Task, Repo, Day}

  def index(conn, %{"day_id" => day_id}) do
    tasks = Repo.all(from task in Task, where: task.day_id == ^day_id)
    conn
    |> put_status(200)
    |> render(:index, tasks: tasks)
  end

  def create(conn, params) do
    changeset = Task.changeset(%Task{}, assign_user_id(conn, params))
    case Repo.insert(changeset) do
      {:ok, task} ->
        conn
        |> put_status(200)
        |> render(:create, task: task)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:error, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id} = params) do
    changeset = Task.changeset(find_task(id), params)
    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_status(200)
        |> render(:update, task: task)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:error, changeset: changeset)
    end
  end

  def destroy(conn, %{"id" => id}) do
    {:ok, task} = find_task(id) |> Repo.delete
    conn
    |> put_status(200)
    |> render(:destroy, task: task)
  end

  #PRIVATE

  defp find_task(id) do
    Task |> Repo.get!(id)
  end

  defp assign_user_id(conn, params) do
    %{"user_id" => conn.assigns[:current_user].id}
    |> Map.merge(params)
  end
end
