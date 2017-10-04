require IEx

defmodule PowerBackend.Battery do
  def current_generation(state) do
    (state.installed_generation * SunPower.get_power(Time.utc_now.hour)) 
    #|> Float.floor
  end
  def charge_storage(state, delay) do
    #state.current_storage + state.current_generation * (delay/3_600_000)
    fusto = state.current_storage + state.current_generation * (delay/3_600_000)
    fuper = (fusto / state.installed_storage)*100 |> Float.floor(2)

    cond do
      percentage(state) < 100 && fuper <= 100 ->
        state.current_storage + state.current_generation * (delay/3_600_000)
      percentage(state) < 100 && fuper > 100 ->
        state.installed_storage
      percentage(state) >= 100 ->
        state.installed_storage
    end
    |> Float.floor(2)
  end
  def consume_storage(state, delay) do
    consumption = state.consumption * (delay/3_600_000)
    case state.installed_storage > consumption do
      true ->
        cache = (state.cache - consumption) |> Float.floor(2)
        {cache, state.current_storage}
      false ->
        csto = (state.current_storage - consumption) |> Float.floor(2)
        {state.cache, csto}
    end
    #state.current_storage - state.consumption * (delay/3_600_000)
    #|> Fstatloat.floor(2)
  end
  def percentage(state) do
    (state.current_storage / state.installed_storage)*100
    |> Float.floor(2)
  end
end
