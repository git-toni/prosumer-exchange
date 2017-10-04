defmodule PowerBackend.Prosumer do
  alias PowerBackend.{Battery,Market}
  use GenServer
  @timedelay 2000
  defmodule State do
    defstruct id: nil, lat: nil, lon: nil, installed_generation: nil, installed_storage: nil, current_storage: nil, prev_generation: nil, current_generation: nil, consumption: nil, cache: nil, purchases: nil, sales: nil
  end
  def start_link(params) do
    #def start_link(_) do
    GenServer.start_link(__MODULE__, params, [])
  end
  def stop(pid) do
    GenServer.call(pid, :stop)
  end
  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def init(params) do
    #clat = 51.505
    #clon = -0.09
    clat = 50.887222
    clon = 10.005556
    :random.seed(:erlang.now)
    #nodes = for i <- 1..5, do: %{id: i, x: clat + :random.uniform()*8, y: clon + :random.uniform()*8}
    randid = :crypto.strong_rand_bytes(44) |> Base.url_encode64 |> binary_part(0, 12)
    installed_storage = Enum.random(5_000..15_000)
    current_storage = round(installed_storage * :random.uniform())
    state = %State{ lat: clat+(:random.uniform()-0.5)*4, 
                    lon: clon+(:random.uniform()-0.5)*4, 
                    id: randid,
                    current_storage: current_storage, 
                    cache: 0, 
                    consumption: Enum.random(0..4_500), 
                    installed_generation: Enum.random(1_000..10_000), 
                    installed_storage: installed_storage }
    send self(), :generate
    :timer.send_interval(@timedelay, :generate)
    :timer.send_interval(@timedelay, :charge)
    :timer.send_interval(@timedelay, :move_consumption)
    :timer.send_interval(@timedelay, :consume_storage)
    #:timer.send_interval(@timedelay*2, :status)
    {:ok, state}
  end
  def handle_info(:generate,  state) do
    cgen = Battery.current_generation(state)
    {:noreply, %{state | prev_generation: state.current_generation, current_generation: cgen}}
  end
  def handle_info(:charge, state) do
    csto = Battery.charge_storage(state, @timedelay)
    #IO.puts "charging #{inspect self()} -- #{state.current_storage}  n:#{csto}"
    {:noreply, %{state | current_storage: csto}}
  end
  def handle_info(:consume_storage,  state) do
    # If percentage < 30% buy 2kwh from market
    # and save inside prosumer.cache

    if Battery.percentage(state) < 30 && state.cache < state.installed_storage do
      tr = Market.purchase(self(),state)
      #Save transaction here ?
    end
    {cache, csto} = Battery.consume_storage(state, @timedelay)
    {:noreply, %{state | cache: cache, current_storage: csto}}
  end
  def handle_info(:move_consumption,  state) do
    consumption = Enum.random(0..4_500)
    {:noreply, %{state | consumption: consumption}}
  end
  def handle_info(:status,  state) do
    #IO.puts "#{inspect self()}::  Storage:#{state.current_storage}  Consump:#{state.consumption}  Generation:#{state.current_generation}"
    {:noreply, state}
  end
  def handle_info({:sell, tr}, state) do
    {:noreply, %{state | current_storage: state.current_storage - tr.amount*1000}}
  end
  def handle_info({:buy, tr}, state) do
    {:noreply, %{state | cache: state.cache + tr.amount*1000}}
  end
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
  #def handle_info(:get_state, state) do
  #  {:reply, state}
  #end
end
