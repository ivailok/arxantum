defmodule Arxantum.Entities.Common do
    def get_new_id(insert_result) do
        insert_result |>
        Map.get(:inserted_id)
    end

    def attach_property(entry, prop, val) do
        entry |>
        Map.put(prop, val);
    end

    def form_list(list, skip, take) do
        list |>
        Enum.drop(skip) |>
        Enum.take(take)
    end
end