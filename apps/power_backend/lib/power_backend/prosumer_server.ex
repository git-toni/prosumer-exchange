require IEx
defmodule PowerBackend.ProsumerServer do
  alias PowerBackend.{ProsumerSupervisor, Prosumer, ProsumerServer, Battery}

  use GenServer
  #import Supervisor.Spec
  defmodule State do
    defstruct pool_sup: nil, worker_sup: nil, monitors: nil, size: nil,
workers: nil, name: nil, mfa: nil
  end
  def start_link do
    #IEx.pry
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def pool_state do
    Supervisor.which_children(ProsumerSupervisor)
    |> Enum.map( &( Prosumer.get_state(elem(&1,1))  ))
  end
  def prosumer_pids do
    Supervisor.which_children(ProsumerSupervisor)
    |> Enum.map( &(elem(&1,1)) )
  end
  def sellers(buyer) do
    #ProsumerServer.pool_state
    #|> Enum.filter(fn(x) -> Battery.percentage(x) > 30 end)
    #Supervisor.which_children(ProsumerSupervisor)
    #|> Enum.map( &(elem(&1,1)) )
    prosumer_pids
    |> Enum.filter(fn(x) -> x != buyer && Battery.percentage(Prosumer.get_state(x)) > 30 end)
  end


  def init(_) do
    send self(), :start_pool
    {:ok, %{}}
  end
  
  def handle_info(:start_pool,state) do
    Enum.each (1..25), fn(_) -> Supervisor.start_child(PowerBackend.ProsumerSupervisor,[[]]) end
    {:noreply, state}
  end

  def handle_call(:status, _from, state) do
    {:reply, %{aloha: 'hola'}, state}
  end
end
