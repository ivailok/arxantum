defmodule ArxantumTest do
  use ExUnit.Case
  doctest Arxantum

  test "Test generate token" do
    token = Arxantum.generate_token()
    assert String.length(token) === 30
  end

  test "Test token validation" do
    token = Arxantum.generate_token()
    assert Arxantum.list_models(token) !== "Invalid token!"
  end

  test "Test create model" do
    token = Arxantum.generate_token()
    name = "test " <> (DateTime.utc_now |> DateTime.to_string)
    new_model = %{"name" => name}
    assert Arxantum.create_model(token, new_model) !== "Invalid token!"
    result = Arxantum.list_models(token, 0, 1000)
    assert result !== "Invalid token!"
    assert (result |> Enum.filter(fn r -> r["name"] == name end) |> Enum.count) === 1
  end

  test "Test create action" do
    token = Arxantum.generate_token()
    date =  DateTime.utc_now |> DateTime.to_string
    new_model = %{"name" => ("test " <> date)}
    assert Arxantum.create_model(token, new_model) !== "Invalid token!"
    result = Arxantum.list_models(token, 0, 1000)
    assert result !== "Invalid token!"

    [%{"_id" => model_id}] = result |> Enum.filter(fn r -> r["name"] == ("test " <> date) end)
    new_action = %{"name" => ("build " <> date)}
    assert Arxantum.create_model_action(token, new_action, model_id) !== "Invalid token!"
    result = Arxantum.list_actions_of_model(token, model_id, 0, 1000)
    assert result !== "Invalid token!"
    assert (result |> Enum.filter(fn r -> r["name"] == ("build " <> date) end) |> Enum.count) === 1
  end

  test "Test create model instance" do
    token = Arxantum.generate_token()
    date =  DateTime.utc_now |> DateTime.to_string
    new_model = %{"name" => ("test " <> date)}
    assert Arxantum.create_model(token, new_model) !== "Invalid token!"
    result = Arxantum.list_models(token, 0, 1000)
    assert result !== "Invalid token!"

    [%{"_id" => model_id}] = result |> Enum.filter(fn r -> r["name"] == ("test " <> date) end)
    new_action = %{"name" => ("build " <> date)}
    assert Arxantum.create_model_action(token, new_action, model_id) !== "Invalid token!"
    result = Arxantum.list_actions_of_model(token, model_id, 0, 1000)
    assert result !== "Invalid token!"
    assert (result |> Enum.filter(fn r -> r["name"] == ("build " <> date) end) |> Enum.count) === 1
    
    [%{"_id" => action_id}] = result |> Enum.filter(fn r -> r["name"] == ("build " <> date) end)
    new_instance = %{"name" => ("house " <> date)}
    assert Arxantum.create_model_instance(token, new_instance, model_id, 1, action_id) !== "Invalid token!";
    result = Arxantum.list_unique_instances(token, 1, 0, 1000)
    assert result !== "Invalid token!"
    assert (result |> Enum.filter(fn r -> r["name"] == ("house " <> date) end) |> Enum.count) === 1
  end
end
