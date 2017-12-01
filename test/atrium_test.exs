defmodule AtriumTest do
  use ExUnit.Case
  doctest Atrium

  test "provides an environment, api_key and client_id" do
    assert Atrium.base_url() == "http://localhost:5000"
    assert Atrium.api_key() == "TEST_API_KEY"
    assert Atrium.client_id() == "TEST_CLIENT_ID"
  end
end
