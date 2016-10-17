defmodule BowlingAlley.Game do
  use GenServer

  @name __MODULE__
  
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  @doc """
  iex> BowlingAlley.Game.add_bowler('Snyder')
  'Snyder'
  """
  def add_bowler(bowler_name) do
    GenServer.call(@name, {:add_bowler, bowler_name})
  end

  @doc """
  iex> BowlingAlley.Game.add_roll('Snyder', 5)
  [5]
  iex> BowlingAlley.Game.add_roll('Snyder',3)
  [5,3]
  """
  def add_roll(bowler_name, pins) do
    GenServer.call(@name, {:add_roll, bowler_name, pins})
  end

  @doc """
  iex> BowlingAlley.Game.add_bowler('Snyder')
  iex> BowlingAlley.Game.add_roll('Snyder', 5)
  iex> BowlingAlley.Game.add_roll('Snyder', 2)
  iex> BowlingAlley.Game.bowler_score('Snyder')
  8
  """
  def bowler_score(bowler_name) do
    GenServer.call(@name, {:bowler_score, bowler_name})
  end    

  @doc """
  iex> BowlingAlley.Game.add_bowler('Snyder')
  iex> BowlingAlley.Game.add_bowler('Sloan')
  iex> BowlingAlley.Game.bowlers
  ['Snyder','Sloan']
  """
  def bowlers do
    GenServer.call(@name, {:bowlers})
  end
  
  def init(:ok) do
    {:ok, %{}} # Initial state
  end

  
  # def handle_info(:started, []) do
  #   IO.puts "#{__MODULE__}#started"
  #   {:noreply, []}
  # end

  def handle_call({:add_bowler, bowler_name}, _from, state) do
    import Supervisor.Spec, warn: false
    opts = [strategy: :one_for_one, name: BowlingAlley.Supervisor]
    {:ok, pid} = GenServer.start_link(BowlingAlley.Scorer, bowler_name)
    
    {:reply, bowler_name, Map.put(state, bowler_name, pid)}
  end

  def handle_call({:add_roll, bowler_name, pins}, _from, state) do
    {:ok, pid} = Map.fetch(state, bowler_name)
    rolls = GenServer.call(pid, {:add_roll, pins})
    
    {:reply, rolls, state}
  end

  def handle_call({:bowler_score, bowler_name}, _from, state) do
    {:ok, pid} = Map.fetch(state, bowler_name)
    rolls = GenServer.call(pid, {:score})
    
    {:reply, rolls, state}
  end

  def handle_call({:bowlers}, _from, state) do
    {:reply, state, state}
  end
  
end
