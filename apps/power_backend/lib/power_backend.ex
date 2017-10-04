defmodule PowerBackend do
  alias PowerBackend.{ProsumerSupervisor, Prosumer, ProsumerServer}
  use Application
  def start(_type, _args) do
    PowerBackend.ProsumerPool.start_link
  end

  def prosumers do
    ProsumerServer.pool_state
    #Supervisor.which_children(ProsumerSupervisor)
  end
end
