defmodule Arxantum do
  use Application

  alias Arxantum.Entities.Model

  @db_name Application.get_env(:arxantum, :db_name)

  def start(_type, _args) do
    Arxantum.Supervisor.start_link(@db_name)
  end

  def create_model(new_model) do
    GenServer.cast(Model, {:insert, new_model})
  end

  def list_models(skip \\ 0, take \\ 10) do
    GenServer.call(Model, {:list, skip, take})
  end
end
