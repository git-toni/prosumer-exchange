require IEx

defmodule BatteryTest do
  alias PowerBackend.Battery
  alias PowerBackend.Prosumer.State
  use ExUnit.Case
  #doctest PowerBackend.Battery

  def installed_genration do 
    Enum.random
  end
  def state do
    #state = %State{
    #  installed_generation: Enum.random(100..4_000),
    #  installed_storage: Enum.random(3_000..10_000)
    #}
    state = %State{
      installed_generation: 4_000,
      installed_storage: 10_000
    }
    state = %{ state | 
      prev_generation: state.installed_generation,
      current_storage: state.installed_storage/2,
      current_generation: state.installed_generation
    }
  end
  def delay do
    10_000
  end
  test "charge_storage increases current_storage" do
    #IEx.pry
    IO.inspect state
    IO.puts state.current_generation
    csto = state.current_storage + state.current_generation * (delay/3_600_000)
    assert Battery.charge_storage(state, delay) == csto
  end
end
