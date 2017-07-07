defmodule Arxantum.Model do
    use GenServer

    def start_link() do
        GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    end

    def init(_) do
        send(self(), :init_models)
        {:ok, nil}
    end

    def handle_info(:init_models, nil) do
        models = Mongo.find(:mongo, "models-collection", %{}) |> Enum.to_list
        {:noreply, models}
    end

    def handle_cast({:insert, new_entry}, models) do
        Mongo.insert_one(:mongo, "models-collection", %{id: 1})
        {:noreply, [new_entry | models]}
    end

    def handle_call({:list, skip, take}, _from, models) do
        result = 
            models |>
            Enum.drop(skip) |>
            Enum.take(take)
        {:reply, result, models}
    end

end