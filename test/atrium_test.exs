defmodule AtriumTest do
  use ExUnit.Case
  doctest Atrium

  test "provides an environment, api_key and client_id" do
    assert is_binary(Atrium.environment())
    assert is_binary(Atrium.api_key())
    assert is_binary(Atrium.client_id())
  end
end
