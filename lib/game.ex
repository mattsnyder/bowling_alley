defmodule BowlingAlley.Game do
  use GenServer

  @name __MODULE__
  
  def start_link() do
    IO.puts "#{__MODULE__}#start_link"

    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def add_bowler(bowler_name) do
    IO.puts "#{__MODULE__}#add_player"
    GenServer.call(@name, {:add_bowler, bowler_name})
  end

  def bowlers do
    GenServer.call(@name, {:bowlers})
  end
  
  def init(:ok) do
#    IO.puts "#{__MODULE__}#init"
#    Process.send_after self(), :started, 1
    {:ok, %{}} # Initial state
  end

  # def handle_info(:started, []) do
  #   IO.puts "#{__MODULE__}#started"
  #   {:noreply, []}
  # end

  def handle_call({:add_bowler, name}, _from, state) do
    {:reply, name, Map.put(state, name, [])}
  end

  def handle_call({:bowlers}, _from, state) do
    {:reply, Map.keys(state), state}
  end
  
end
