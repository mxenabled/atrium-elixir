defmodule Atrium.ConnectTest do
  use ExUnit.Case, async: false
  doctest Atrium

  alias Atrium.{Connect, Users}

  setup _ do
    {:ok, %{}}
  end

  describe "create_widget" do
    test "create_widget/1" do
      {:ok, response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      user_guid = response["user"]["guid"]

      {:ok, response} = Connect.create_widget(user_guid)

      assert response["user"]["guid"] == user_guid

      assert %{
               "user" => %{
                 "connect_widget_url" => _,
                 "guid" => _
               }
             } = response

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end
end
