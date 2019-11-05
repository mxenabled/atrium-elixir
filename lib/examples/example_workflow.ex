defmodule ExampleWorkflow do
  @moduledoc """
  THIS IS OLD CODE AND IS OUTDATED. USE AS REFERENCE BUT NOT LAW.

  Please look at the unit tests for verified working code.
  """

  def run_example() do
    ExampleWorkflow.start()
  end

  def checkJobStatus(user_guid, member_guid, counter) do
    IO.puts("\n2 second delay...")
    :timer.sleep(2000)

    member = Atrium.Members.read_member_connection_status(user_guid, member_guid)
    code = member["status"]

    IO.puts("\nJOB STATUS: " <> code)

    if code == "COMPLETED" do
      readAggregationData(user_guid, member_guid)
    else
      if code == "HALTED" or code == "FAILED" or code == "ERRORED" do
        currentTime =
          String.slice(to_string(DateTime.utc_now() |> DateTime.to_iso8601()), 0..-9) <> "+00:00"

        member = Atrium.Members.read_member_connection_status(user_guid, member_guid)
        lastSuccessTime = member["successfully_aggregated_at"]

        # Check if last successful aggregation over 3 days aggregation
        if lastSuccessTime != nil and
             (abs(String.slice(currentTime, 8..9) - String.slice(lastSuccessTime, 8..9)) > 3 or
                abs(String.slice(currentTime, 5..6) - String.slice(lastSuccessTime, 5..6)) > 0 or
                abs(String.slice(currentTime, 0..3) - String.slice(lastSuccessTime, 0..3)) > 0) do
          IO.puts("\nClient should contact MX Support to resolve issue.")
        else
          IO.puts("\nAn update is currently unavailable. Please try again tomorrow")
        end
      else
        if code == "CREATED" or code == "UPDATED" or code == "RESUMED" or code == "CONNECTED" or
             code == "DEGRADED" or code == "DELAYED" or code == "INITIATED" or code == "REQUESTED" or
             code == "AUTHENTICATED" or code == "RECEIVED" or code == "TRANSFERRED" do
          checkJobStatus(user_guid, member_guid, counter)
        else
          if code == "PREVENTED" or code == "DENIED" or code == "IMPAIRED" do
            member = Atrium.Members.read_member(user_guid, member_guid)
            institution_code = member["institution_code"]

            IO.puts("\nPlease update credentials")
            credentials = Atrium.Institutions.read_institution_credentials(institution_code)

            {:ok, updatedCredentials} = Agent.start_link(fn -> [] end)

            Enum.each(credentials, fn credential ->
              cred =
                String.trim(
                  IO.gets("\nPlease enter in " <> to_string(credential["label"]) <> ": ")
                )

              Agent.update(updatedCredentials, fn list ->
                [%{guid: credential["guid"], value: cred} | list]
              end)
            end)

            creds = Agent.get(updatedCredentials, fn list -> list end)

            Atrium.Members.update_member(user_guid, member_guid, credentials: creds)

            checkJobStatus(user_guid, member_guid, counter)
          else
            if code == "CHALLENGED" do
              IO.puts("\nPlease answer the following challenges: ")
              challenges = Atrium.Members.list_member_mfa_challenges(user_guid, member_guid)

              {:ok, answer} = Agent.start_link(fn -> [] end)

              Enum.each(challenges, fn challenge ->
                cred = String.trim(IO.gets("\n" <> to_string(challenge["label"]) <> ": "))

                Agent.update(answer, fn list ->
                  [%{guid: challenge["guid"], value: cred} | list]
                end)
              end)

              creds = Agent.get(answer, fn list -> list end)

              Atrium.Members.resume_member_aggregate(user_guid, member_guid, creds)

              checkJobStatus(user_guid, member_guid, counter)
            else
              if code == "REJECTED" do
                Atrium.Members.aggregate_member(user_guid, member_guid)

                checkJobStatus(user_guid, member_guid, counter)
              else
                if code == "EXPIRED" do
                  IO.puts("\nUser did not answer MFA in time. Please try again tomorrow.")
                else
                  if code == "LOCKED" do
                    IO.puts("\nUser's account is locked at FI")
                  else
                    if code == "IMPEDED" do
                      IO.puts(
                        "\nUser's attention is required at FI website in order for aggregation to complete"
                      )
                    else
                      if code == "DISCONTINUED" do
                        IO.puts("\nConnection to institution is no longer available.")
                      else
                        if code == "CLOSED" or code == "DISABLED" do
                          IO.puts("\nAggregation is purposely turned off for this user.")
                        else
                          if code == "TERMINATED" or code == "ABORTED" or code == "STOPPED" or
                               code == "THROTTLED" or code == "SUSPENDED" or code == "ERRORED" do
                            # Check JobStatus() an additional 2 times to see if status changed
                            if Agent.get(counter, fn x -> x end) < 3 do
                              Agent.update(counter, fn x -> x + 1 end)
                              checkJobStatus(user_guid, member_guid, counter)
                            else
                              IO.puts(
                                "\nAn update is currently unavailable. Please try again tomorrow and contact support if unsuccessful after 3 days."
                              )

                              Agent.update(counter, fn x -> x - 3 end)
                            end
                          else
                            IO.puts(code)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def readAggregationData(user_guid, member_guid) do
    Atrium.Members.read_member(user_guid, member_guid)

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
  end

  def start() do
    {:ok, counter} = Agent.start_link(fn -> 0 end)

    user_guid =
      String.trim(IO.gets("Please enter in user GUID. If not yet created just press enter key: "))

    member_guid =
      String.trim(
        IO.gets("\nPlease enter in member GUID. If not yet created just press enter key: ")
      )

    endUserPresent =
      String.trim(IO.gets("\nPlease enter in if end user is present (true or false): "))

    if user_guid == "" and member_guid != "" do
      IO.puts("\nMust include user GUID when member GUID is entered.")
      System.halt(0)
    end

    user_guid =
      if user_guid == "" and endUserPresent == "true" do
        IO.puts("\n* Creating user *")

        identifier = String.trim(IO.gets("\nPlease enter in an unique id for user: "))

        user = Atrium.Users.create_user(identifier: identifier)
        IO.puts("\nCreated user: " <> user["guid"])
        user["guid"]
      else
        user_guid
      end

    if member_guid != "" and endUserPresent == "true" do
      Atrium.Members.aggregate_member(user_guid, member_guid)
      checkJobStatus(user_guid, member_guid, counter)
    else
      if member_guid != "" do
        readAggregationData(user_guid, member_guid)
      else
        if endUserPresent == "true" do
          IO.puts("\n* Creating new member *")

          institutions = Atrium.Institutions.list_institutions()

          IO.puts("\n* Listing top 15 institutions *")

          Enum.each(institutions, fn institution ->
            IO.puts(
              to_string(institution["name"]) <>
                " : institution code = " <> to_string(institution["code"])
            )
          end)

          institution_code = String.trim(IO.gets("\nPlease enter in desired institution code: "))

          credentials = Atrium.Institutions.read_institution_credentials(institution_code)

          {:ok, updatedCredentials} = Agent.start_link(fn -> [] end)

          Enum.each(credentials, fn credential ->
            cred =
              String.trim(IO.gets("\nPlease enter in " <> to_string(credential["label"]) <> ": "))

            Agent.update(updatedCredentials, fn list ->
              [%{guid: credential["guid"], value: cred} | list]
            end)
          end)

          creds = Agent.get(updatedCredentials, fn list -> list end)

          member = Atrium.Members.create_member(user_guid, creds, institution_code)

          member_guid = member["guid"]
          IO.puts("\nCreated member: " <> member_guid)
          checkJobStatus(user_guid, member_guid, counter)
        else
          IO.puts("\nEnd user must be present to create a new member")
          System.halt(0)
        end
      end
    end
  end
end
