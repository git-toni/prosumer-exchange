defmodule PowerBackend.ProsumerSupervisor do
  use Supervisor
  def start_link do
    Supervisor.start_link(__MODULE__, {PowerBackend.Prosumer, :start_link, []}, name: __MODULE__)
  end
  def init({m,f,a}) do
    worker_opts = [restart: :permanent, shutdown: 5000, function: f]
    children = [worker(m, a, worker_opts)]
    #children = [worker(PowerBackend.Prosumer, [])]
    #children = [worker(PowerBackend.Prosumer, [], worker_opts)]
    opts =
    [strategy:
       :simple_one_for_one,
       max_restarts: 5,
       max_seconds: 5]
    supervise(children, opts)

  end
end
