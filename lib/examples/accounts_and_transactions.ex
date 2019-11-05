defmodule Atrium.Examples.AccountsAndTransactions do
  @moduledoc """
  THIS IS OLD CODE AND IS OUTDATED. USE AS REFERENCE BUT NOT LAW.

  Please look at the unit tests for verified working code.
  """

  def run_example() do
    IO.puts("\n* Creating user and member *")

    user = Atrium.Users.create_user()
    user_guid = user["guid"]
    IO.puts("Created user: " <> user_guid)

    credentialArray = []

    credentialArray = [
      %{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium"} | credentialArray
    ]

    credentialArray = [
      %{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "password"} | credentialArray
    ]

    member = Atrium.Members.create_member(user_guid, credentialArray, "mxbank")
    member_guid = member["guid"]
    IO.puts("Created member: " <> member_guid)

    :timer.sleep(1000)

    IO.puts("\n* Aggregating member *")
    Atrium.Members.aggregate_member(user_guid, member_guid)

    :timer.sleep(4000)
    IO.puts("Member aggregation status: " <> member["status"])

    IO.puts("\n* Listing all member accounts and transactions *")
    accounts = Atrium.Members.list_member_accounts(user_guid, member_guid)

    Enum.each(accounts, fn account ->
      IO.puts(
        "Type: " <>
          to_string(account["type"]) <>
          "\tName: " <>
          to_string(account["name"]) <>
          "\tAvailable Balance: " <>
          to_string(account["available_balance"]) <>
          "\tAvailable Credit: " <> to_string(account["available_credit"])
      )

      IO.puts("Transactions")
      transactions = Atrium.Accounts.list_account_transactions(user_guid, account["guid"])

      Enum.each(transactions, fn transaction ->
        IO.puts(
          "Date: " <>
            to_string(transaction["date"]) <>
            "\tDescription: " <>
            to_string(transaction["description"]) <>
            "\tAmount: " <> to_string(transaction["amount"])
        )
      end)
    end)

    IO.puts("\n* Deleting test user *")
    Atrium.Users.delete_user(user_guid)
    IO.puts("Deleted user: " <> user_guid)
  end
end
