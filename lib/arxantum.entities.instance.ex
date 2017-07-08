defmodule Arxantum.Entities.Instance do
    use GenServer

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

    def handle_cast({:insert, new_entry, model_id}, instances) do

        new_entry = 
            new_entry |> 
            Map.put("model_id", model_id);
        {:ok, result} = Mongo.insert_one(:mongo, "instances-collection", new_entry)

        id =
            result |>
            Map.get(:inserted_id)

        new_entry_plus_id = 
            new_entry |>
            Map.put("_id", id)

        {:noreply, [new_entry_plus_id | instances]}
    end

    def handle_call({:list, model_id, skip, take}, _from, instances) do
        result = 
            instances |>
            Enum.filter(fn i -> i["model_id"] == model_id end) |>
            Enum.drop(skip) |>
            Enum.take(take)
        {:reply, result, instances}
    end

    def handle_call({:list, skip, take}, _from, instances) do
        result = 
            instances |>
            Enum.drop(skip) |>
            Enum.take(take)
        {:reply, result, instances}
    end

end