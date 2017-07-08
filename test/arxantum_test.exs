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
end
