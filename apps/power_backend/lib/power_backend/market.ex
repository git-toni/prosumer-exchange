defmodule PowerBackend.Market do
  alias PowerBackend.{Money,ProsumerServer}

  def purchase(buyer_pid, state) do
    #Find seller within the global pool
    seller_pid = 45
    seller = %{id: 45}
    # Get current KWH price from Market
    price = 18 # 18cts/kwh
    amount = 2 # kWh
    transaction = Money.transaction(state, seller, amount, price)
    send buyer_pid, {:buy, transaction}
    #case find_seller(buyer_pid) do
    #  {:ok, seller_pid} ->
    #    #Buy from local market
    #    transaction = Money.transaction(buyer_pid, seller_pid, amount, price)
    #    send seller_pid, {:sell, transaction}
    #    send buyer_pid, {:buy, transaction}
    #    transaction
    #  :error ->
    #    #Buy from external market
    #    transaction = Money.external_tr(buyer_pid, amount, price)
    #    send buyer_pid, {:buy, transaction}
    #    transaction
    #end
  end
  def find_seller(buyer) do
    ProsumerServer.sellers(buyer)
    |> Enum.fetch(0)
  end
end
