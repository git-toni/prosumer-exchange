defmodule PowerWeb.Web.WorldChannel do
  use Phoenix.Channel

  def join("world:main", _message, socket) do
    send self, :ping
    :timer.send_interval(5000, :ping)
    #push socket, "stats", %{ name: :rand.uniform(), ncars: 45, nuser: 9 }
    {:ok, socket}
  end
  def handle_info(:ping, socket) do
    clat = 51.505
    clon = -0.09
    :random.seed(:erlang.now)
    #nodes = for i <- 1..5, do: %{id: i, x: clat + :random.uniform()*8, y: clon + :random.uniform()*8}
    nodes = PowerBackend.prosumers
    #IO.inspect nodes
    push socket, "stats", %{nodes: nodes}
    {:noreply, socket}
  end
end
