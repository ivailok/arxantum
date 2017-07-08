defmodule Arxantum.Supervisor do
    use Supervisor

    def start_link(db_name) do
        Supervisor.start_link(__MODULE__, db_name, name: __MODULE__)
    end

    def init(db_name) do
        children = [
            worker(Mongo, [[name: :mongo, database: db_name]]),
            supervisor(Arxantum.Entities.Supervisor, [])
        ]

        opts = [strategy: :one_for_all]
        supervise(children, opts)
    end
end