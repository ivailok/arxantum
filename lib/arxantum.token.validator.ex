defmodule Arxantum.Token.Validator do
    @moduledoc """
    This module validates tokens
    """

    use GenServer

    @doc """
    Starts the GenServer
    """
    def start_link() do
        GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    end

    @doc """
    Validates a token
    """
    def handle_call({:validate, token}, _from, tokens) do
        result = 
            Mongo.find(:mongo, "tokens-collection", %{"token" => token}) |> 
            Enum.count
        {:reply, result > 0, tokens}
    end
end