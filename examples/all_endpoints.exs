IO.puts "\n************************** Create User **************************"
user = Atrium.createUser(metadata: "{\"first_name\": \"Steven\"}")
IO.inspect user
userGUID = user["guid"]

IO.puts "\n************************** Read User **************************"
user = Atrium.readUser(userGUID)
IO.inspect user

IO.puts "\n************************** Update User **************************"
user = Atrium.updateUser(userGUID, metadata: "{\"first_name\": \"Steven\", \"last_name\": \"Universe\"}")
IO.inspect user

IO.puts "\n************************** List Users **************************"
users = Atrium.listUsers()
Enum.each(users, fn user ->
  IO.inspect user
end)

IO.puts "\n************************** List Institutions **************************"
institutions = Atrium.listInstitutions(name: "bank")
Enum.each(institutions, fn institution ->
  IO.inspect institution
end)

IO.puts "\n************************** Read Institution **************************"
institution = Atrium.readInstitution("mxbank")
IO.inspect institution

IO.puts "\n************************** Read Institution Credentials************************** "
credentials = Atrium.readInstitutionCredentials("mxbank")
Enum.each(credentials, fn credential ->
  IO.inspect credential
end)

IO.puts "\n************************** Create Member **************************"
# Create credential array
credentialArray = []
credentialArray = [%{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium1"} | credentialArray]
credentialArray = [%{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "challenge1"} | credentialArray]

member = Atrium.createMember(userGUID, credentialArray, "mxbank")
IO.inspect member
memberGUID = member["guid"]

IO.puts "\n************************** Read Member **************************"
member = Atrium.readMember(userGUID, memberGUID)
IO.inspect member

IO.puts "\n************************** Update Member **************************"
# Create credential array
credentialArray = []
credentialArray = [%{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium"} | credentialArray]
credentialArray = [%{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "challenge"} | credentialArray]

member = Atrium.updateMember(userGUID, memberGUID, credentials: credentialArray, metadata: "{\"credentials_last_refreshed_at\": \"2015-10-16\"}")
IO.inspect member

IO.puts "\n************************** List Members **************************"
members = Atrium.listMembers(userGUID)
Enum.each(members, fn member ->
  IO.inspect member
end)

IO.puts "\n************************** Aggregate Member **************************"
member = Atrium.aggregateMember(userGUID, memberGUID)
IO.inspect member

IO.puts "\n************************** Read Member Status **************************"
:timer.sleep(5000)
member = Atrium.readMemberAggregationStatus(userGUID, memberGUID)
IO.inspect member

IO.puts "\n************************** List Member MFA Challenges **************************"
challenges = Atrium.listMemberMFAChallenges(userGUID, memberGUID)
Enum.each(challenges, fn challenge ->
  IO.inspect challenge
end)

challengeGUID = List.first(challenges)["guid"]

IO.puts "\n************************** Resume Aggregation **************************"
# Create credential array
credentialArray = []
credentialArray = [%{guid: challengeGUID, value: "correct"} | credentialArray]

member = Atrium.resumeMemberAggregation(userGUID, memberGUID, credentialArray)
IO.inspect member

IO.puts "\n************************** List Member Credentials **************************"
credentials = Atrium.listMemberCredentials(userGUID, memberGUID)
Enum.each(credentials, fn credential ->
  IO.inspect credential
end)

IO.puts "\n************************** List Member Accounts **************************"
:timer.sleep(5000)
accounts = Atrium.listMemberAccounts(userGUID, memberGUID)
Enum.each(accounts, fn account ->
  IO.inspect account
end)
accountGUID = List.first(accounts)["guid"]

IO.puts "\n************************** List Member Transactions **************************"
transactions = Atrium.listMemberTransactions(userGUID, memberGUID)
Enum.each(transactions, fn transaction ->
  IO.inspect transaction
end)

IO.puts "\n************************** Read Account **************************"
account = Atrium.readAccount(userGUID, accountGUID)
IO.inspect account

IO.puts "\n************************** List Accounts for User **************************"
accounts = Atrium.listAccounts(userGUID)
Enum.each(accounts, fn account ->
  IO.inspect account
end)

IO.puts "\n************************** List Account Transactions **************************"
transactions = Atrium.listAccountTransactions(userGUID, accountGUID)
Enum.each(transactions, fn transaction ->
  IO.inspect transaction
end)
transactionGUID = List.first(transactions)["guid"]

IO.puts "\n************************** Read a Transaction **************************"
transaction = Atrium.readTransaction(userGUID, transactionGUID)
IO.inspect transaction

IO.puts "\n************************** List Transactions **************************"
transactions = Atrium.listTransactions(userGUID)
Enum.each(transactions, fn transaction ->
  IO.inspect transaction
end)

IO.puts "\n************************** Connect Widget **************************"
user = Atrium.createWidget(userGUID)
IO.inspect user

IO.puts "\n************************** Delete Member **************************"
response = Atrium.deleteMember(userGUID, memberGUID)
IO.puts response

IO.puts "\n************************** Delete User **************************"
response = Atrium.deleteUser(userGUID)
IO.puts response
