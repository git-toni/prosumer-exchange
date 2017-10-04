require IEx

defmodule PowerBackend.ProsumerPool do
  use Supervisor
  def start_link do
    #IEx.pry
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end
  def init(_) do
    opts = [
      strategy: :one_for_all
    ]
    children = [
      supervisor(PowerBackend.ProsumerSupervisor, []),
      worker(PowerBackend.ProsumerServer, [])
    ]
    supervise(children, opts)
  end
end
