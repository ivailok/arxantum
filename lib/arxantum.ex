defmodule Arxantum do
  use Application

  alias Arxantum.Entities.Model
  alias Arxantum.Entities.Instance
  alias Arxantum.Entities.Action
  alias Arxantum.Token.Generator
  alias Arxantum.Token.Validator

  @db_name Application.get_env(:arxantum, :db_name)

  def start(_type, _args) do
    Arxantum.Supervisor.start_link(@db_name)
  end

  def generate_token() do
    GenServer.call(Generator, {:generate})
  end

  def list_tokens(skip \\ 0, take \\ 10) do
    GenServer.call(Generator, {:list, skip, take})
  end

  defp validate_token?(token) do
    GenServer.call(Validator, {:validate, token})
  end

  @doc """
  Creating model
  """
  def create_model(token, new_model) do
    if (validate_token?(token)) do
      GenServer.cast(Model, {:insert, new_model})
    else
      "Invalid token!"
    end
  end

  def list_models(token, skip \\ 0, take \\ 10) do
    if (validate_token?(token)) do
      GenServer.call(Model, {:list, skip, take})
    else
      "Invalid token!"
    end
  end

  def create_model_instance(token, new_entity, model_id, unique_instance_id, action_id) do
    if (validate_token?(token)) do
      GenServer.cast(Instance, {:insert, new_entity, model_id, unique_instance_id, action_id})
    else
      "Invalid token!"
    end
  end

  def list_instances_of_model(token, model_id, skip \\ 0, take \\ 10) do
    if (validate_token?(token)) do
      GenServer.call(Instance, {:list_by_model, model_id, skip, take})
    else
      "Invalid token!"
    end
  end

  def list_instances(token, skip \\ 0, take \\ 10) do
    if (validate_token?(token)) do
      GenServer.call(Instance, {:list_all, skip, take})
    else
      "Invalid token!"
    end
  end

  def list_unique_instances(token, unique_instance_id, skip \\ 0, take \\ 10) do
    if (validate_token?(token)) do
      GenServer.call(Instance, {:list_by_unique_instance_id, unique_instance_id, skip, take})
    else
      "Invalid token!"
    end
  end

  def list_actions_of_model(token, model_id, skip \\ 0, take \\ 10) do
    if (validate_token?(token)) do
      GenServer.call(Action, {:list, model_id, skip, take})
    else
      "Invalid token!"
    end
  end

  def create_model_action(token, new_entity, model_id) do
    if (validate_token?(token)) do
      GenServer.cast(Action, {:insert, new_entity, model_id})
    else
      "Invalid token!"
    end
  end
end
