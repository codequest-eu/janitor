defmodule MessageOperations do
  @doc """
  Spawns process with possibility to wait for messages.

  Returns pid.

  ## Examples
      mb_pid = MessageOperations.start_mock_messagebox
      send(mb_pid, :something)
      MessageOperations.flush_messages(mb_pid)
  """
  def start_mock_messagebox do
    parent_id = self()
    spawn fn -> messagebox_server(parent_id) end
  end

  @doc """
  Returns all messages received by mock messagebox process.

  ## Example with Phoenix Channels
      mbox = MessageOperations.start_mock_messagebox
      MyApp.Endpoint.subscribe mbox, "test:channel"

      MyApp.Endpoint.broadcast! "test:channel", "event", %{some: :message}
      MessageOperations.flush_messages(mbox)
      =>[%Phoenix.Socket.Broadcast{event: "event", payload: %{some: :message}, topic: "test:channel"}]
  """
  def flush_messages(pid) do
    send pid, :STOP

    receive do
      {^pid, messages} ->
        messages
      _ ->
        IO.puts :stderr, "Unexpected message received"
    after
      50 ->
        IO.puts :stderr, "No message in 50 ms, are you using correct process id?"
    end
  end

  defp messagebox_server(parent_id, messages \\ []) do
    receive do
      :STOP ->
        send(parent_id, {self, messages})
      msg ->
        messagebox_server(parent_id, [msg | messages])
    end
  end
end
