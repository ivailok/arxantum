defmodule Arxantum.Entities.Action do
    @moduledoc """
    Represents module about action creation and listing
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
        send(self(), :init_actions)
        {:ok, nil}
    end

    @doc """
    Initializes the actions
    """
    def handle_info(:init_actions, nil) do
        actions = Mongo.find(:mongo, "actions-collection", %{}) |> Enum.to_list
        {:noreply, actions}
    end

    @doc """
    Creates new action linked with model
    """
    def handle_cast({:insert, new_entry, model_id}, actions) do
        new_entry = 
            new_entry |>
            Common.attach_property("model_id", model_id) |>
            Common.attach_property("created_date", DateTime.utc_now |> DateTime.to_string)
        {:ok, result} = Mongo.insert_one(:mongo, "actions-collection", new_entry)
        id = Common.get_new_id(result)
        new_entry_plus_id = Common.attach_property(new_entry, "_id", id)
        {:noreply, [new_entry_plus_id | actions]}
    end

    @doc """
    Lists actions for certain model in range (or page)
    """
    def handle_call({:list, model_id, skip, take}, _from, actions) do
        result = Common.form_list(actions |> Enum.filter(fn i -> i["model_id"] == model_id end), skip, take)
        {:reply, result, actions}
    end

    @doc """
    Lists all actions in range (or page)
    """
    def handle_call({:list, skip, take}, _from, actions) do
        result = Common.form_list(actions, skip, take)
        {:reply, result, actions}
    end

end