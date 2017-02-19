defmodule Janitor.FinalizeMonthlyCommitment do 
  import Janitor.DaysQueryHelpers
  import Ecto.Query
  alias Janitor.{Repo, User}

  def call do 
    days = get_ramining_days
    users = get_users(length(days))
    [days, users]|> List.zip |> List.map(&assign_user(&1))
  end 

  defp get_ramining_days do 
    from_month
    query = from d in from_month, where: d.user_id == nil
    query |> Repo.all
  end 

  defp get_users(days_length) do 
    User |> order_by([u], [asc: u.points]) |> limit(days_length) |> Repo.all
  end 

  defp assign_user(data) do 
    {day, user} = data
    day = Ecto.Changeset.change day, user_id: user.id
    Repo.update!(day)
    add_points(user)
  end 

  def add_points(user) do 
    user = Ecto.Changeset.change user, points: (user.points + 1)
    Repo.update!(user)
  end 
end 
