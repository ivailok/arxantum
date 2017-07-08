defmodule Arxantum.Entities.Common do
    @moduledoc """
    Represents common helper
    """

    @doc """
    Extracts the new id of a document
    """
    def get_new_id(insert_result) do
        insert_result |>
        Map.get(:inserted_id)
    end

    @doc """
    Attaches property with its value to a document
    """
    def attach_property(entry, prop, val) do
        entry |>
        Map.put(prop, val);
    end

    @doc """
    Applies paging to list
    """
    def form_list(list, skip, take) do
        list |>
        Enum.drop(skip) |>
        Enum.take(take)
    end
end