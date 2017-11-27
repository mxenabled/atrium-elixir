defmodule UpdateCredentials do
  use Application

  def start(_type, _args) do

    IO.puts "\n* Creating user and member with \"DENIED\" aggregation status *"

    user = Atrium.createUser()
    userGUID = user["guid"]
    IO.puts "Created user: " <> userGUID

    credentialArray = []
    credentialArray = [%{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium"} | credentialArray]
    credentialArray = [%{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "INVALID"} | credentialArray]

    member = Atrium.createMember(userGUID, credentialArray, "mxbank")

    memberGUID = member["guid"]
    IO.puts "Created member: " <> memberGUID

    :timer.sleep(1000)


    IO.puts "\n* Retrieving member aggregation status *"
    member = Atrium.readMemberAggregationStatus(userGUID, memberGUID)
    IO.puts "Member aggregation status: " <> member["status"]


    member = Atrium.readMember(userGUID, memberGUID)
    institutionCode = member["institution_code"]

    IO.puts "\n* Updating credentials *"
    credentials = Atrium.readInstitutionCredentials(institutionCode)

    updatedCredentials = []
    updatedCredentials = [%{guid: List.first(credentials)["guid"], value: "test_atrium"} | updatedCredentials]
    credentials = List.delete_at(credentials, 0)
    updatedCredentials = [%{guid: List.first(credentials)["guid"], value: "password"} | updatedCredentials]

    Atrium.updateMember(userGUID, memberGUID, credentials: updatedCredentials)


    :timer.sleep(1000)


    IO.puts "\n* Retrieving member aggregation status *"
    member = Atrium.readMemberAggregationStatus(userGUID, memberGUID)
    IO.puts "Member aggregation status: " <> member["status"]


    IO.puts "\n* Deleting test user *"
    Atrium.deleteUser(userGUID)
    IO.puts "Deleted user: " <> userGUID
  end
end
