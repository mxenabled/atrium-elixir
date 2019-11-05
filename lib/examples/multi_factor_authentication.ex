defmodule Atrium.Examples.MultiFactorAuthentication do
  @moduledoc """
  THIS IS OLD CODE AND IS OUTDATED. USE AS REFERENCE BUT NOT LAW.

  Please look at the unit tests for verified working code.
  """

  def run_example() do
    IO.puts("\n* Creating user and member with \"CHALLENGED\" aggregation status *")

    user = Atrium.Users.create_user()
    user_guid = user["guid"]
    IO.puts("Created user: " <> user_guid)

    credentialArray = []

    credentialArray = [
      %{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium"} | credentialArray
    ]

    credentialArray = [
      %{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "challenge"} | credentialArray
    ]

    member = Atrium.Members.create_member(user_guid, credentialArray, "mxbank")

    member_guid = member["guid"]
    IO.puts("Created member: " <> member_guid)

    :timer.sleep(1000)

    IO.puts("\n* Retrieving member aggregation status *")
    member = Atrium.Members.read_member_connection_status(user_guid, member_guid)
    IO.puts("Member aggregation status: " <> member["status"])

    IO.puts("\n* MFA Challenge *")
    challenges = Atrium.Members.list_member_mfa_challenges(user_guid, member_guid)

    Enum.each(challenges, fn challenge ->
      IO.puts(challenge["label"])
    end)

    responses = []
    responses = [%{guid: List.first(challenges)["guid"], value: "correct"} | responses]

    IO.puts("\n* MFA Answered Correctly *")
    Atrium.Members.resume_member_aggregate(user_guid, member_guid, responses)

    :timer.sleep(1000)

    IO.puts("\n* Retrieving member aggregation status *")
    member = Atrium.Members.read_member_connection_status(user_guid, member_guid)
    IO.puts("Member aggregation status: " <> member["status"])

    IO.puts("\n* Deleting test user *")
    Atrium.Users.delete_user(user_guid)
    IO.puts("Deleted user: " <> user_guid)
  end
end
