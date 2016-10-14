defmodule BowlingAlley.Scorer do
  use GenServer

  def start_link(bowler_name) do
    IO.puts "#{__MODULE__}#start_link"

    GenServer.start_link(__MODULE__, :ok)
  end

  def init(player_name) do
    IO.puts "#{__MODULE__}#init(#{player_name})"
    {:ok, []}
  end

  def handle_call({add_roll, pins}, _from, state) do
    {:reply, state ++ [pins], state ++ [pins]}
  end
  
end
