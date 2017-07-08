defmodule Arxantum.Entities.Supervisor do
    @moduledoc """
    Supervises the following GenServers:
    Arxantum.Entities.Model
    Arxantum.Entities.Instance
    Arxantum.Entities.Action
    Arxantum.Token.Generator
    """

    use Supervisor

    alias Arxantum.Entities.Model
    alias Arxantum.Entities.Instance
    alias Arxantum.Entities.Action
    alias Arxantum.Token.Generator

    @doc """
    Starts the Supervisor
    """
    def start_link() do
        Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
    end

    @doc """
    Invoked after start_link
    """
    def init(_) do
        children = [
            worker(Model, []),
            worker(Instance, []),
            worker(Action, []),
            worker(Generator, [])
        ]

        opts = [strategy: :one_for_one]
        supervise(children, opts)
    end
end