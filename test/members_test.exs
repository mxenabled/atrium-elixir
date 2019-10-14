defmodule Atrium.MembersTest do
  use ExUnit.Case, async: false
  doctest Atrium

  alias Atrium.{Institutions, Members, Users}

  setup _ do
    {:ok, %{}}
  end

  describe "create_member" do
    test "create_member/4" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "CREATED",
                 "guid" => _,
                 "identifier" => nil,
                 "institution_code" => "mxbank",
                 "is_being_aggregated" => true,
                 "metadata" => nil,
                 "name" => "MX Bank",
                 "status" => "INITIATED",
                 "successfully_aggregated_at" => nil,
                 "user_guid" => _
               }
             } = member_response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} =
               Members.delete_member(user_guid, member_response["member"]["guid"])

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "create_member!/4" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      member_response = Members.create_member!(user_guid, credentials, "mxbank")

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "CREATED",
                 "guid" => _,
                 "identifier" => nil,
                 "institution_code" => "mxbank",
                 "is_being_aggregated" => true,
                 "metadata" => nil,
                 "name" => "MX Bank",
                 "status" => "INITIATED",
                 "successfully_aggregated_at" => nil,
                 "user_guid" => _
               }
             } = member_response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} =
               Members.delete_member(user_guid, member_response["member"]["guid"])

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "read_member" do
    test "read_member/2" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")

      member_guid = member_response["member"]["guid"]

      {:ok, response} = Members.read_member(user_guid, member_guid)

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "CREATED",
                 "guid" => _,
                 "identifier" => nil,
                 "institution_code" => "mxbank",
                 "is_being_aggregated" => true,
                 "metadata" => nil,
                 "name" => "MX Bank",
                 "status" => "INITIATED",
                 "successfully_aggregated_at" => nil,
                 "user_guid" => _
               }
             } = response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)

      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "read_member!/2" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")

      member_guid = member_response["member"]["guid"]

      response = Members.read_member!(user_guid, member_guid)

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "CREATED",
                 "guid" => _,
                 "identifier" => nil,
                 "institution_code" => "mxbank",
                 "is_being_aggregated" => true,
                 "metadata" => nil,
                 "name" => "MX Bank",
                 "status" => "INITIATED",
                 "successfully_aggregated_at" => nil,
                 "user_guid" => _
               }
             } = response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "update_member" do
    test "update_member/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      {:ok, response} =
        Members.update_member(user_guid, member_guid, metadata: "{\"first_name\": \"Steven\"}")

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "CREATED",
                 "guid" => _,
                 "identifier" => nil,
                 "institution_code" => "mxbank",
                 "is_being_aggregated" => true,
                 "metadata" => "{\"first_name\": \"Steven\"}",
                 "name" => "MX Bank",
                 "status" => _,
                 "successfully_aggregated_at" => nil,
                 "user_guid" => _
               }
             } = response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "update_member!/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      response =
        Members.update_member!(user_guid, member_guid, metadata: "{\"first_name\": \"Steven\"}")

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "CREATED",
                 "guid" => _,
                 "identifier" => nil,
                 "institution_code" => "mxbank",
                 "is_being_aggregated" => true,
                 "metadata" => "{\"first_name\": \"Steven\"}",
                 "name" => "MX Bank",
                 "status" => _,
                 "successfully_aggregated_at" => nil,
                 "user_guid" => _
               }
             } = response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "delete_member" do
    test "delete_member/2" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "list_members" do
    test "list_members/2" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      {:ok, member_list} = Members.list_members(user_guid)

      assert %{
               "members" => [
                 %{
                   "aggregated_at" => _,
                   "connection_status" => "CREATED",
                   "guid" => _,
                   "identifier" => nil,
                   "institution_code" => "mxbank",
                   "is_being_aggregated" => true,
                   "metadata" => nil,
                   "name" => "MX Bank",
                   "status" => _,
                   "successfully_aggregated_at" => nil,
                   "user_guid" => _
                 }
               ],
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 1,
                 "total_pages" => 1
               }
             } = member_list

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "list_members!/2" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      member_list = Members.list_members!(user_guid)

      assert %{
               "members" => [
                 %{
                   "aggregated_at" => _,
                   "connection_status" => "CREATED",
                   "guid" => _,
                   "identifier" => nil,
                   "institution_code" => "mxbank",
                   "is_being_aggregated" => true,
                   "metadata" => nil,
                   "name" => "MX Bank",
                   "status" => _,
                   "successfully_aggregated_at" => nil,
                   "user_guid" => _
                 }
               ],
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 1,
                 "total_pages" => 1
               }
             } = member_list

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "aggregate_member" do
    test "aggregate_member/2" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      {:ok, response} = Members.aggregate_member(user_guid, member_guid)

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "CREATED",
                 "guid" => _,
                 "identifier" => nil,
                 "institution_code" => "mxbank",
                 "is_being_aggregated" => true,
                 "metadata" => nil,
                 "name" => "MX Bank",
                 "status" => _,
                 "successfully_aggregated_at" => nil,
                 "user_guid" => _
               }
             } = response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "aggregate_member!/2" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      response = Members.aggregate_member!(user_guid, member_guid)

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "CREATED",
                 "guid" => _,
                 "identifier" => nil,
                 "institution_code" => "mxbank",
                 "is_being_aggregated" => true,
                 "metadata" => nil,
                 "name" => "MX Bank",
                 "status" => _,
                 "successfully_aggregated_at" => nil,
                 "user_guid" => _
               }
             } = response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "read_member_connection_status" do
    test "read_member_connection_status/2" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]
      {:ok, _aggregate_response} = Members.aggregate_member(user_guid, member_guid)

      Process.sleep(5_000)
      {:ok, response} = Members.read_member_connection_status(user_guid, member_guid)

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "DENIED",
                 "guid" => _,
                 "has_processed_accounts" => false,
                 "has_processed_transactions" => false,
                 "is_being_aggregated" => false,
                 "status" => "DENIED",
                 "successfully_aggregated_at" => nil
               }
             } = response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "read_member_connection_status!/2" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]
      {:ok, _aggregate_response} = Members.aggregate_member(user_guid, member_guid)

      Process.sleep(5_000)
      response = Members.read_member_connection_status!(user_guid, member_guid)

      assert %{
               "member" => %{
                 "aggregated_at" => _,
                 "connection_status" => "DENIED",
                 "guid" => _,
                 "has_processed_accounts" => false,
                 "has_processed_transactions" => false,
                 "is_being_aggregated" => false,
                 "status" => "DENIED",
                 "successfully_aggregated_at" => nil
               }
             } = response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "list_member_mfa_challenges" do
    test "list_member_mfa_challenges/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      # This api endpoint is difficult to test without MFA enabled.
      assert {:ok, "204: No Content"} = Members.list_member_mfa_challenges(user_guid, member_guid)

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "list_member_mfa_challenges!/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      # This api endpoint is difficult to test without MFA enabled.
      response = Members.list_member_mfa_challenges!(user_guid, member_guid)
      assert response == "204: No Content"

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  @tag :incomplete
  describe "resume_member_aggregate" do
    # incomplete
  end

  describe "list_member_credentials" do
    test "list_member_credentials/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      {:ok, credentail_response} = Members.list_member_credentials(user_guid, member_guid)

      assert %{
               "credentials" => [
                 %{
                   "display_order" => 1,
                   "field_name" => "LOGIN",
                   "guid" => _,
                   "label" => "Username",
                   "type" => "LOGIN"
                 },
                 %{
                   "display_order" => 2,
                   "field_name" => "PASSWORD",
                   "guid" => _,
                   "label" => "Password",
                   "type" => "PASSWORD"
                 }
               ]
             } = credentail_response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "list_member_credentials!/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      credentail_response = Members.list_member_credentials!(user_guid, member_guid)

      assert %{
               "credentials" => [
                 %{
                   "display_order" => 1,
                   "field_name" => "LOGIN",
                   "guid" => _,
                   "label" => "Username",
                   "type" => "LOGIN"
                 },
                 %{
                   "display_order" => 2,
                   "field_name" => "PASSWORD",
                   "guid" => _,
                   "label" => "Password",
                   "type" => "PASSWORD"
                 }
               ]
             } = credentail_response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "list_member_accounts" do
    test "list_member_accounts/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      {:ok, account_response} = Members.list_member_accounts(user_guid, member_guid)

      assert %{
               "accounts" => [],
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 0,
                 "total_pages" => 1
               }
             } = account_response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "list_member_accounts!/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      account_response = Members.list_member_accounts!(user_guid, member_guid)

      assert %{
               "accounts" => [],
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 0,
                 "total_pages" => 1
               }
             } = account_response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  describe "list_member_transactions" do
    test "list_member_transactions/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      {:ok, transaction_response} = Members.list_member_transactions(user_guid, member_guid)

      assert %{
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 0,
                 "total_pages" => 1
               },
               "transactions" => []
             } = transaction_response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end

    test "list_member_transactions!/3" do
      {:ok, user_response} = Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
      {:ok, institution_credential_response} = Institutions.read_institution_credentials("mxbank")

      user_guid = user_response["user"]["guid"]

      credentials =
        Enum.map(institution_credential_response["credentials"], fn credential ->
          %{guid: credential["guid"], value: credential["type"]}
        end)

      {:ok, member_response} = Members.create_member(user_guid, credentials, "mxbank")
      member_guid = member_response["member"]["guid"]

      transaction_response = Members.list_member_transactions!(user_guid, member_guid)

      assert %{
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 0,
                 "total_pages" => 1
               },
               "transactions" => []
             } = transaction_response

      # Clean up member created in test.
      assert {:ok, "204: No Content"} = Members.delete_member(user_guid, member_guid)
      # Clean up user created in test.
      assert {:ok, "204: No Content"} = Users.delete_user(user_guid)
    end
  end

  @tag :incomplete
  describe "verify_member" do
    # incomplete
  end

  @tag :incomplete
  describe "identify_member" do
    # incomplete
  end
end
