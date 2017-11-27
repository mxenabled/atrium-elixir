defmodule UserAndMemberCreation do
  use Application

  def start(_type, _args) do

    IO.puts "\n* Creating user *"

    user = Atrium.createUser
    userGUID = user["guid"]
    IO.puts "Created user: " <> userGUID


    IO.puts "\n* Listing institutions with query string \"bank\" *"

    institutions = Atrium.listInstitutions(name: "bank")
    Enum.each(institutions, fn institution ->
      IO.puts to_string(institution["name"]) <> " : institution code = " <> to_string(institution["code"])
    end)


    IO.puts "\n* Reading institution \"mxbank\" *"
    institution = Atrium.readInstitution("mxbank")
    IO.puts institution["name"]


    IO.puts "\n* Reading institution credentials \"mxbank\" *"
    credentials = Atrium.readInstitutionCredentials("mxbank")
    Enum.each(credentials, fn credential ->
      IO.puts credential["guid"]
    end)


    IO.puts "\n* Creating member *"

    # Create credential array
    credentialArray = []
    credentialArray = [%{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium"} | credentialArray]
    credentialArray = [%{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "password"} | credentialArray]

    member = Atrium.createMember(userGUID, credentialArray, "mxbank")
    IO.puts "Created member: " <> member["guid"]


    IO.puts "\n* Deleting test user *"
    Atrium.deleteUser(userGUID)
    IO.puts "Deleted user: " <> userGUID
  end
end
