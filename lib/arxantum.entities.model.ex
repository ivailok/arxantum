defmodule Arxantum.Entities.Model do
    @moduledoc """
    Represents module about model creation and listing
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
        send(self(), :init_models)
        {:ok, nil}
    end

    @doc """
    Initializes the models
    """
    def handle_info(:init_models, nil) do
        models = Mongo.find(:mongo, "models-collection", %{}) |> Enum.to_list
        {:noreply, models}
    end

    @doc """
    Creates new model
    """
    def handle_cast({:insert, new_entry}, models) do
        new_entry = Common.attach_property(new_entry, "created_date", DateTime.utc_now |> DateTime.to_string)
        {:ok, result} = Mongo.insert_one(:mongo, "models-collection", new_entry)
        id = Common.get_new_id(result)
        new_entry_plus_id = Common.attach_property(new_entry, "_id", id)
        {:noreply, [new_entry_plus_id | models]}
    end

    @doc """
    Lists models in range (or page)
    """
    def handle_call({:list, skip, take}, _from, models) do
        result = Common.form_list(models, skip, take)
        {:reply, result, models}
    end

end