defmodule Arxantum.Supervisor do
    @moduledoc """
    Supervises the following GenServers and Supervisors:
    Mongo
    Arxantum.Token.Validator
    Arxantum.Entities.Supervisor
    """

    use Supervisor

    @doc """
    Starts the Supervisor
    """
    def start_link(db_name) do
        Supervisor.start_link(__MODULE__, db_name, name: __MODULE__)
    end

    @doc """
    Invoked after start_link
    """
    def init(db_name) do
        children = [
            worker(Mongo, [[name: :mongo, database: db_name]]),
            worker(Arxantum.Token.Validator, []),
            supervisor(Arxantum.Entities.Supervisor, [])
        ]

        opts = [strategy: :one_for_all]
        supervise(children, opts)
    end
end