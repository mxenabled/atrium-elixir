defmodule Atrium.UsersTest do
  use ExUnit.Case, async: false
  doctest Atrium

  alias Atrium.Users

  setup _ do
    # Deletes the users created in each test.
    # The dev environment limits the developers to 100 users.
    # This cleans the users created in the test up before each test.
    # https://atrium.mx.com/docs#getting-started

    response = Users.list_users!()

    Enum.each(response["users"], fn user ->
      Users.delete_user(user["guid"])
    end)

    {:ok, %{}}
  end

  describe "create_user" do
    @tag :sandbox
    test "create_user/1" do
      assert {:ok, response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")

      assert %{
               "user" => %{
                 "guid" => guid,
                 "identifier" => nil,
                 "is_disabled" => false,
                 "metadata" => "{\"first_name\": \"Steven\"}"
               }
             } = response

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(response["user"]["guid"])
    end

    @tag :sandbox
    test "create_user!/1" do
      response = Users.create_user!(metadata: "{\"first_name\": \"Steven\"}")

      assert %{
               "user" => %{
                 "guid" => _,
                 "identifier" => nil,
                 "is_disabled" => false,
                 "metadata" => "{\"first_name\": \"Steven\"}"
               }
             } = response

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(response["user"]["guid"])
    end
  end

  describe "read_user" do
    @tag :sandbox
    test "read_user/1" do
      {:ok, response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      user_guid = response["user"]["guid"]

      assert {:ok, response} = Users.read_user(user_guid)

      assert %{
               "user" => %{
                 "guid" => _,
                 "identifier" => nil,
                 "is_disabled" => false,
                 "metadata" => "{\"first_name\": \"Steven\"}"
               }
             } = response

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    @tag :sandbox
    test "read_user!/1" do
      {:ok, response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      user_guid = response["user"]["guid"]

      assert response = Users.read_user!(user_guid)

      assert %{
               "user" => %{
                 "guid" => _,
                 "identifier" => nil,
                 "is_disabled" => false,
                 "metadata" => "{\"first_name\": \"Steven\"}"
               }
             } = response

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "update_user" do
    @tag :sandbox
    test "update_user/1" do
      {:ok, response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      user_guid = response["user"]["guid"]

      assert {:ok, response} =
               Users.update_user(user_guid, metadata: "{\"last_name\": \"Universe\"}")

      assert %{
               "user" => %{
                 "guid" => _,
                 "identifier" => nil,
                 "is_disabled" => false,
                 "metadata" => "{\"last_name\": \"Universe\"}"
               }
             } = response

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    @tag :sandbox
    test "update_user!/1" do
      {:ok, response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      user_guid = response["user"]["guid"]

      response = Users.update_user!(user_guid, metadata: "{\"last_name\": \"Universe\"}")

      assert %{
               "user" => %{
                 "guid" => _,
                 "identifier" => nil,
                 "is_disabled" => false,
                 "metadata" => "{\"last_name\": \"Universe\"}"
               }
             } = response

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "delete_user" do
    @tag :sandbox
    test "delete_user/1" do
      {:ok, response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      user_guid = response["user"]["guid"]

      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "list_users" do
    @tag :sandbox
    test "list_users/1" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")

      assert {:ok, response} = Users.list_users()

      assert %{
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 1,
                 "total_pages" => 1
               },
               "users" => [
                 %{
                   "guid" => _,
                   "identifier" => nil,
                   "is_disabled" => false,
                   "metadata" => "{\"first_name\": \"Steven\"}"
                 }
               ]
             } = response

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_response["user"]["guid"])
    end

    @tag :sandbox
    test "list_users!/1" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")

      response = Users.list_users!()

      assert %{
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 1,
                 "total_pages" => 1
               },
               "users" => [
                 %{
                   "guid" => _,
                   "identifier" => nil,
                   "is_disabled" => false,
                   "metadata" => "{\"first_name\": \"Steven\"}"
                 }
               ]
             } = response

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_response["user"]["guid"])
    end
  end
end
