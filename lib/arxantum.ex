defmodule Arxantum do
  use Application

  alias Arxantum.Entities.Model
  alias Arxantum.Entities.Instance
  alias Arxantum.Entities.Action

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

  def create_model_instance(new_entity, model_id, unique_instance_id, action_id) do
    GenServer.cast(Instance, {:insert, new_entity, model_id, unique_instance_id, action_id})
  end

  def list_instances_of_model(model_id, skip \\ 0, take \\ 10) do
    GenServer.call(Instance, {:list_by_model, model_id, skip, take})
  end

  def list_instances(skip \\ 0, take \\ 10) do
    GenServer.call(Instance, {:list_all, skip, take})
  end

  def list_unique_instances(unique_instance_id, skip \\ 0, take \\ 10) do
    GenServer.call(Instance, {:list_by_unique_instance_id, unique_instance_id, skip, take})
  end

  def list_actions_of_model(model_id, skip \\ 0, take \\ 10) do
    GenServer.call(Action, {:list, model_id, skip, take})
  end

  def create_model_action(new_entity, model_id) do
    GenServer.cast(Action, {:insert, new_entity, model_id})
  end
end
