defmodule Arxantum.Entities.Action do
    use GenServer

    alias Arxantum.Entities.Common

    def start_link() do
        GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    end

    def init(_) do
        send(self(), :init_actions)
        {:ok, nil}
    end

    def handle_info(:init_actions, nil) do
        actions = Mongo.find(:mongo, "actions-collection", %{}) |> Enum.to_list
        {:noreply, actions}
    end

    def handle_cast({:insert, new_entry, model_id}, actions) do
        new_entry = Common.attach_property(new_entry, "model_id", model_id)
        {:ok, result} = Mongo.insert_one(:mongo, "actions-collection", new_entry)
        id = Common.get_new_id(result)
        new_entry_plus_id = Common.attach_property(new_entry, "_id", id)
        {:noreply, [new_entry_plus_id | actions]}
    end

    def handle_call({:list, model_id, skip, take}, _from, actions) do
        result = Common.form_list(actions |> Enum.filter(fn i -> i["model_id"] == model_id end), skip, take)
        {:reply, result, actions}
    end

    def handle_call({:list, skip, take}, _from, actions) do
        result = Common.form_list(actions, skip, take)
        {:reply, result, actions}
    end

end