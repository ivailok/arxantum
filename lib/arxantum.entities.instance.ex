defmodule Arxantum.Entities.Instance do
    use GenServer

    alias Arxantum.Entities.Common

    def start_link() do
        GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    end

    def init(_) do
        send(self(), :init_instances)
        {:ok, nil}
    end

    def handle_info(:init_instances, nil) do
        instances = Mongo.find(:mongo, "instances-collection", %{}) |> Enum.to_list
        {:noreply, instances}
    end

    def handle_cast({:insert, new_entry, model_id, unique_instance_id, action_id}, instances) do
        new_entry = 
            new_entry |>
            Common.attach_property("model_id", model_id) |>
            Common.attach_property("unique_instance_id", unique_instance_id) |>
            Common.attach_property("action_id", action_id) |>
            Common.attach_property("created_date", DateTime.utc_now)
        
        {:ok, result} = Mongo.insert_one(:mongo, "instances-collection", new_entry)
        id = Common.get_new_id(result)
        new_entry_plus_id = Common.attach_property(new_entry, "_id", id)
        {:noreply, [new_entry_plus_id | instances]}
    end

    def handle_call({:list_by_model, model_id, skip, take}, _from, instances) do
        result = Common.form_list(instances |> Enum.filter(fn i -> i["model_id"] == model_id end), skip, take)
        {:reply, result, instances}
    end

    def handle_call({:list_all, skip, take}, _from, instances) do
        result = Common.form_list(instances, skip, take)
        {:reply, result, instances}
    end

    def handle_call({:list_by_unique_instance_id, unique_instance_id, skip, take}, _from, instances) do
        result = Common.form_list(instances |> Enum.filter(fn i -> i["unique_instance_id"] == unique_instance_id end), skip, take)
        {:reply, result, instances}
    end

end