defmodule Atrium.Examples.AllEndpoints do
  @moduledoc """
  THIS IS OLD CODE AND IS OUTDATED. USE AS REFERENCE BUT NOT LAW.

  Please look at the unit tests for verified working code.
  """

  def run_example do
    IO.puts("\n************************** Create User **************************")
    user = Atrium.Users.create_user(metadata: "{\"first_name\": \"Steven\"}")
    IO.inspect(user)
    user_guid = user["guid"]

    IO.puts("\n************************** Read User **************************")
    user = Atrium.Users.read_user(user_guid)
    IO.inspect(user)

    IO.puts("\n************************** Update User **************************")

    user =
      Atrium.Users.update_user(user_guid,
        metadata: "{\"first_name\": \"Steven\", \"last_name\": \"Universe\"}"
      )

    IO.inspect(user)

    IO.puts("\n************************** List Users **************************")
    users = Atrium.Users.list_users()

    Enum.each(users, fn user ->
      IO.inspect(user)
    end)

    IO.puts("\n************************** List Institutions **************************")
    institutions = Atrium.Institutions.list_institutions(name: "bank")

    Enum.each(institutions, fn institution ->
      IO.inspect(institution)
    end)

    IO.puts("\n************************** Read Institution **************************")
    institution = Atrium.Institutions.read_institution("mxbank")
    IO.inspect(institution)

    IO.puts(
      "\n************************** Read Institution Credentials************************** "
    )

    credentials = Atrium.Institutions.read_institution_credentials("mxbank")

    Enum.each(credentials, fn credential ->
      IO.inspect(credential)
    end)

    IO.puts("\n************************** Create Member **************************")
    # Create credential array
    credentialArray = []

    credentialArray = [
      %{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium1"} | credentialArray
    ]

    credentialArray = [
      %{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "challenge1"} | credentialArray
    ]

    member = Atrium.Members.create_member(user_guid, credentialArray, "mxbank")
    IO.inspect(member)
    member_guid = member["guid"]

    IO.puts("\n************************** Read Member **************************")
    member = Atrium.Members.read_member(user_guid, member_guid)
    IO.inspect(member)

    IO.puts("\n************************** Update Member **************************")
    # Create credential array
    credentialArray = []

    credentialArray = [
      %{guid: "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1", value: "test_atrium"} | credentialArray
    ]

    credentialArray = [
      %{guid: "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d", value: "challenge"} | credentialArray
    ]

    member =
      Atrium.Members.update_member(user_guid, member_guid,
        credentials: credentialArray,
        metadata: "{\"credentials_last_refreshed_at\": \"2015-10-16\"}"
      )

    IO.inspect(member)

    IO.puts("\n************************** List Members **************************")
    members = Atrium.Members.list_members(user_guid)

    Enum.each(members, fn member ->
      IO.inspect(member)
    end)

    IO.puts("\n************************** Aggregate Member **************************")
    member = Atrium.Members.aggregate_member(user_guid, member_guid)
    IO.inspect(member)

    IO.puts("\n************************** Read Member Status **************************")
    :timer.sleep(5000)
    member = Atrium.Members.read_member_connection_status(user_guid, member_guid)
    IO.inspect(member)

    IO.puts("\n************************** List Member MFA Challenges **************************")
    challenges = Atrium.Members.list_member_mfa_challenges(user_guid, member_guid)

    Enum.each(challenges, fn challenge ->
      IO.inspect(challenge)
    end)

    challenge_guid = List.first(challenges)["guid"]

    IO.puts("\n************************** Resume Aggregation **************************")
    # Create credential array
    credentialArray = []
    credentialArray = [%{guid: challenge_guid, value: "correct"} | credentialArray]

    member = Atrium.Members.resume_member_aggregate(user_guid, member_guid, credentialArray)
    IO.inspect(member)

    IO.puts("\n************************** List Member Credentials **************************")
    credentials = Atrium.Members.list_member_credentials(user_guid, member_guid)

    Enum.each(credentials, fn credential ->
      IO.inspect(credential)
    end)

    IO.puts("\n************************** List Member Accounts **************************")
    :timer.sleep(5000)
    accounts = Atrium.Members.list_member_accounts(user_guid, member_guid)

    Enum.each(accounts, fn account ->
      IO.inspect(account)
    end)

    account_guid = List.first(accounts)["guid"]

    IO.puts("\n************************** List Member Transactions **************************")
    transactions = Atrium.Members.list_member_transactions(user_guid, member_guid)

    Enum.each(transactions, fn transaction ->
      IO.inspect(transaction)
    end)

    IO.puts("\n************************** Read Account **************************")
    account = Atrium.Accounts.read_account(user_guid, account_guid)
    IO.inspect(account)

    IO.puts("\n************************** List Accounts for User **************************")
    accounts = Atrium.Accounts.list_accounts(user_guid)

    Enum.each(accounts, fn account ->
      IO.inspect(account)
    end)

    IO.puts("\n************************** List Account Transactions **************************")
    transactions = Atrium.Accounts.list_account_transactions(user_guid, account_guid)

    Enum.each(transactions, fn transaction ->
      IO.inspect(transaction)
    end)

    transaction_guid = List.first(transactions)["guid"]

    IO.puts("\n************************** Categorize Transactions **************************")

    transactions = %{
      transactions: [
        %{
          amount: 11.22,
          description: "BEER BAR 65000000764SALT LAKE C",
          identifier: "12",
          type: "DEBIT"
        },
        %{
          amount: 21.33,
          description: "IN-N-OUT BURGER #239AMERICAN FO",
          identifier: "13",
          type: "DEBIT"
        },
        %{
          amount: 1595.33,
          description: "ONLINE PAYMENT - THANK YOU",
          identifier: "14",
          type: "CREDIT"
        }
      ]
    }

    Atrium.Transactions.categorize_and_describe_transactions(transactions)
    |> Enum.each(&IO.inspect/1)

    IO.puts("\n************************** Read a Transaction **************************")
    transaction = Atrium.Transactions.read_transaction(user_guid, transaction_guid)
    IO.inspect(transaction)

    IO.puts("\n************************** List Transactions **************************")
    transactions = Atrium.Transactions.list_transactions(user_guid)

    Enum.each(transactions, fn transaction ->
      IO.inspect(transaction)
    end)

    IO.puts("\n************************** Connect Widget **************************")
    user = Atrium.Connect.create_widget(user_guid)
    IO.inspect(user)

    IO.puts("\n************************** Delete Member **************************")
    response = Atrium.Members.delete_member(user_guid, member_guid)
    IO.puts(response)

    IO.puts("\n************************** Delete User **************************")
    response = Atrium.Users.delete_user(user_guid)
    IO.puts(response)
  end
end
