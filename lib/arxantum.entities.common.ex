defmodule Arxantum.Entities.Common do
    def get_new_id(insert_result) do
        insert_result |>
        Map.get(:inserted_id)
    end

    def attach_model_id(new_entry, model_id) do
        new_entry |>
        Map.put("model_id", model_id);
    end

    def attach_new_id(new_entry, id) do
        new_entry |>
        Map.put("_id", id)
    end

    def form_list(list, skip, take) do
        list |>
        Enum.drop(skip) |>
        Enum.take(take)
    end
end