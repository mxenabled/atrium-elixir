defmodule AccountsAndTransactions do
  use Application

  def start(_type, _args) do

    IO.puts "\n* Creating user and member *"

    user = Atrium.createUser()
    userGUID = user["guid"]
    IO.puts "Created user: " <> userGUID

    credentialArray = []
    credentialArray = [%{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium"} | credentialArray]
    credentialArray = [%{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "password"} | credentialArray]

    member = Atrium.createMember(userGUID, credentialArray, "mxbank")
    memberGUID = member["guid"]
    IO.puts "Created member: " <> memberGUID

    :timer.sleep(1000)


    IO.puts "\n* Aggregating member *"
    Atrium.aggregateMember(userGUID, memberGUID)

    :timer.sleep(4000)
    IO.puts "Member aggregation status: " <> member["status"]


    IO.puts "\n* Listing all member accounts and transactions *"
    accounts = Atrium.listMemberAccounts(userGUID, memberGUID)

    Enum.each(accounts, fn account ->
      IO.puts "Type: " <> to_string(account["type"]) <> "\tName: " <> to_string(account["name"]) <> "\tAvailable Balance: " <> to_string(account["available_balance"]) <> "\tAvailable Credit: " <> to_string(account["available_credit"])
      IO.puts "Transactions"
      transactions = Atrium.listAccountTransactions(userGUID, account["guid"])
      Enum.each(transactions, fn transaction ->
        IO.puts "Date: " <> to_string(transaction["date"]) <> "\tDescription: " <> to_string(transaction["description"]) <> "\tAmount: " <> to_string(transaction["amount"])
      end)
    end)


    IO.puts "\n* Deleting test user *"
    Atrium.deleteUser(userGUID)
    IO.puts "Deleted user: " <> userGUID
  end
end
