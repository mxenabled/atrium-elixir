defmodule Atrium.Examples.UserAndMemberCreation do
  @moduledoc """
  THIS IS OLD CODE AND IS OUTDATED. USE AS REFERENCE BUT NOT LAW.

  Please look at the unit tests for verified working code.
  """

  def run_example() do
    IO.puts("\n* Creating user *")

    user = Atrium.Users.create_user()
    user_guid = user["guid"]
    IO.puts("Created user: " <> user_guid)

    IO.puts("\n* Listing institutions with query string \"bank\" *")

    institutions = Atrium.Institutions.list_institutions(name: "bank")

    Enum.each(institutions, fn institution ->
      IO.puts(
        to_string(institution["name"]) <>
          " : institution code = " <> to_string(institution["code"])
      )
    end)

    IO.puts("\n* Reading institution \"mxbank\" *")
    institution = Atrium.Institutions.read_institution("mxbank")
    IO.puts(institution["name"])

    IO.puts("\n* Reading institution credentials \"mxbank\" *")
    credentials = Atrium.Institutions.read_institution_credentials("mxbank")

    Enum.each(credentials, fn credential ->
      IO.puts(credential["guid"])
    end)

    IO.puts("\n* Creating member *")

    # Create credential array
    credentialArray = []

    credentialArray = [
      %{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium"} | credentialArray
    ]

    credentialArray = [
      %{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "password"} | credentialArray
    ]

    member = Atrium.Members.create_member(user_guid, credentialArray, "mxbank")
    IO.puts("Created member: " <> member["guid"])

    IO.puts("\n* Deleting test user *")
    Atrium.Users.delete_user(user_guid)
    IO.puts("Deleted user: " <> user_guid)
  end
end
