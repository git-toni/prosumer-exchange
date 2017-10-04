defmodule PowerBackend.Money do
  def transaction(buyer, seller, amount, price) do
    %{id: Enum.random(100..10_000), 
      total_price: amount*price, 
      amount: amount,
      unit_price: price,
      buyer: buyer.id, 
      seller: seller.id}
  end
  def external_tr(buyer, amount, price) do
    %{id: Enum.random(100..10_000), 
      total_price: amount*price, 
      amount: amount,
      unit_price: price,
      buyer: buyer.id}
  end
end
