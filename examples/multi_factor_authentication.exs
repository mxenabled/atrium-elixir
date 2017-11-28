IO.puts "\n* Creating user and member with \"CHALLENGED\" aggregation status *"

user = Atrium.createUser()
userGUID = user["guid"]
IO.puts "Created user: " <> userGUID

credentialArray = []
credentialArray = [%{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium"} | credentialArray]
credentialArray = [%{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "challenge"} | credentialArray]

member = Atrium.createMember(userGUID, credentialArray, "mxbank")

memberGUID = member["guid"]
IO.puts "Created member: " <> memberGUID

:timer.sleep(1000)


IO.puts "\n* Retrieving member aggregation status *"
member = Atrium.readMemberAggregationStatus(userGUID, memberGUID)
IO.puts "Member aggregation status: " <> member["status"]


IO.puts "\n* MFA Challenge *"
challenges = Atrium.listMemberMFAChallenges(userGUID, memberGUID)
Enum.each(challenges, fn challenge ->
  IO.puts challenge["label"]
end)
responses = []
responses = [%{guid: List.first(challenges)["guid"], value: "correct"} | responses]


IO.puts "\n* MFA Answered Correctly *"
Atrium.resumeMemberAggregation(userGUID, memberGUID, responses)

:timer.sleep(1000)


IO.puts "\n* Retrieving member aggregation status *"
member = Atrium.readMemberAggregationStatus(userGUID, memberGUID)
IO.puts "Member aggregation status: " <> member["status"]


IO.puts "\n* Deleting test user *"
Atrium.deleteUser(userGUID)
IO.puts "Deleted user: " <> userGUID
