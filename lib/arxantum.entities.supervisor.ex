defmodule Arxantum.Entities.Supervisor do
    use Supervisor

    alias Arxantum.Entities.Model
    alias Arxantum.Entities.Instance
    alias Arxantum.Entities.Action

    def start_link() do
        Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
    end

    def init(_) do
        children = [
            worker(Model, []),
            worker(Instance, []),
            worker(Action, [])
        ]

        opts = [strategy: :one_for_one]
        supervise(children, opts)
    end
end