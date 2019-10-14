defmodule AtriumTest do
  use ExUnit.Case, async: false
  doctest Atrium

  describe "Tests that env vars are set up" do
    test "api_key" do
      assert Atrium.api_key() == "YOUR_MX_API_KEY"
    end

    test "client_id" do
      assert Atrium.client_id() == "YOUR_MX_CLIENT_ID"
    end

    test "base_url" do
      assert Atrium.base_url() == "https://vestibule.mx.com"
    end
  end
end
