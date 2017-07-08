defmodule Arxantum.Token.Generator do
    @moduledoc """
    This module generates tokens
    """

    use GenServer

    alias Arxantum.Entities.Common

    @doc """
    Starts the GenServer
    """
    def start_link() do
        GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    end

    @doc """
    Invoked after start_link
    """
    def init(_) do
        send(self(), :init_tokens)
        {:ok, nil}
    end

    @doc """
    Initializes the tokens
    """
    def handle_info(:init_tokens, nil) do
        tokens = Mongo.find(:mongo, "tokens-collection", %{}) |> Enum.to_list
        {:noreply, tokens}
    end

    @doc """
    Creates new token
    """
    def handle_call({:generate}, _from, tokens) do
        token = generate_token();
        new_entry = %{"token" => token, "created_date" => DateTime.utc_now };
        {:ok, _} = Mongo.insert_one(:mongo, "tokens-collection", new_entry)
        {:reply, token, [new_entry | tokens]}
    end

    @doc """
    Lists tokens in range (or page)
    """
    def handle_call({:list, skip, take}, _from, tokens) do
        result = Common.form_list(tokens, skip, take)
        {:reply, result, tokens}
    end

    defp generate_token() do
        symbols = 
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_@!#$%&abcdefghijklmnopqrstuvwxyz" |>
            String.split("", trim: true)
        length = 30;

        (1..length) |>
        Enum.reduce([], fn(_, acc) -> [Enum.random(symbols) | acc] end) |>
        Enum.join("")
    end
end