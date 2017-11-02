defmodule ExampleWorkflow do
  use Application

  def checkJobStatus(userGUID, memberGUID, counter) do
    IO.puts("\n2 second delay...")
    :timer.sleep(2000)

    aggregationResponse = AtriumClient.readMemberAggregationStatus(userGUID, memberGUID)


    {:ok, parsedJSON} = Poison.decode(to_string(aggregationResponse))
    code = parsedJSON["member"]["status"]

    IO.puts "\nJOB STATUS: " <> code

    if code == "COMPLETED" do
      readAggregationData(userGUID, memberGUID)
    else
      if (code == "HALTED") or (code == "FAILED") or (code == "ERRORED") do
        currentTime = String.slice(to_string(DateTime.utc_now() |> DateTime.to_iso8601()), 0..-9) <> "+00:00"

        statusResponse = AtriumClient.readMemberAggregationStatus(userGUID, memberGUID)
        {:ok, parsedJSON} = Poison.decode(to_string(statusResponse))
        lastSuccessTime = parsedJSON["member"]["successfully_aggregated_at"]

        # Check if last successful aggregation over 3 days aggregation
        if (lastSuccessTime != nil) and (abs(String.slice(currentTime, 8..9) - String.slice(lastSuccessTime, 8..9)) > 3 or abs(String.slice(currentTime, 5..6) - String.slice(lastSuccessTime, 5..6)) > 0 or abs(String.slice(currentTime, 0..3) - String.slice(lastSuccessTime, 0..3)) > 0) do
          IO.puts "\nClient should contact MX Support to resolve issue."
        else
          IO.puts "\nAn update is currently unavailable. Please try again tomorrow"
        end
      else
        if (code == "CREATED") or (code == "UPDATED") or (code == "RESUMED") or (code == "CONNECTED") or (code == "DEGRADED") or (code == "DELAYED") or (code == "INITIATED") or (code == "REQUESTED") or (code == "AUTHENTICATED") or (code == "RECEIVED") or (code == "TRANSFERRED") do
          checkJobStatus(userGUID, memberGUID, counter)
        else
          if (code == "PREVENTED") or (code == "DENIED") or (code == "IMPAIRED") do
            readMemberData = AtriumClient.readMember(userGUID, memberGUID)
            {:ok, parsedJSON} = Poison.decode(to_string(readMemberData))
            institutionCode = parsedJSON["member"]["institution_code"]

            IO.puts "\nPlease update credentials"
            requiredCredentials = AtriumClient.readInstitutionCredentials(institutionCode, "", "")

            {:ok, parsedJSON} = Poison.decode(to_string(requiredCredentials))


            {:ok, credentials} = Agent.start_link fn -> [] end
            Enum.each(parsedJSON["credentials"], fn item ->
              cred = String.trim(IO.gets("\nPlease enter in " <> to_string(item["label"]) <> ": "))
              Agent.update(credentials, fn list -> [%{guid: item["guid"], value: cred} | list] end)
            end)

            creds = Agent.get(credentials, fn list -> list end)

            AtriumClient.updateMember(userGUID, memberGUID, creds, "", "")

            checkJobStatus(userGUID, memberGUID, counter)
          else
            if code == "CHALLENGED" do
              IO.puts "\nPlease answer the following challenges: "
              challengeResponse = AtriumClient.listMemberMFAChallenges(userGUID, memberGUID, "", "")
              {:ok, parsedJSON} = Poison.decode(to_string(challengeResponse))

              # {:ok, answer} = Agent.start_link fn -> [] end
              # Agent.update(answer, fn list -> ["]}}" | list] end)
              # Enum.each(parsedJSON["challenges"], fn item ->
              #   cred = String.trim(IO.gets(to_string(item["label"]) <> ": "))
              #   Agent.update(answer, fn list -> [",{\"guid\":\"" <> item["guid"] <> "\",\"value\":\"" <> cred <> "\"}" | list] end)
              # end)
              # ans = String.slice(to_string(Agent.get(answer, fn list -> list end)), 1..-1)
              # ans = "{\"member\":{\"challenges\":[" <> ans

              #
              {:ok, answer} = Agent.start_link fn -> [] end
              Enum.each(parsedJSON["challenges"], fn item ->
                cred = String.trim(IO.gets("\nPlease enter in " <> to_string(item["label"]) <> ": "))
                Agent.update(answer, fn list -> [%{guid: item["guid"], value: cred} | list] end)
              end)

              creds = Agent.get(answer, fn list -> list end)
              #

              AtriumClient.resumeMemberAggregation(userGUID, memberGUID, creds)

              checkJobStatus(userGUID, memberGUID, counter)
            else
              if code == "REJECTED" do
                AtriumClient.aggregateMember(userGUID, memberGUID)

                checkJobStatus(userGUID, memberGUID, counter)
              else
                if code == "EXPIRED" do
                  IO.puts "\nUser did not answer MFA in time. Please try again tomorrow."
                else
                  if code == "LOCKED" do
                    IO.puts "\nUser's account is locked at FI"
                  else
                    if code == "IMPEDED" do
                      IO.puts "\nUser's attention is required at FI website in order for aggregation to complete"
                    else
                      if code == "DISCONTINUED" do
                        IO.puts "\nConnection to institution is no longer available."
                      else
                        if code == "CLOSED" or code == "DISABLED" do
                          IO.puts "\nAggregation is purposely turned off for this user."
                        else
                          if code == "TERMINATED" or code == "ABORTED" or code == "STOPPED" or code == "THROTTLED" or code == "SUSPENDED" or code == "ERRORED" do
                            # Check JobStatus() an additional 2 times to see if status changed
                            if Agent.get(counter, fn x -> x end) < 3 do
                              Agent.update(counter, fn x -> x + 1 end)
                              checkJobStatus(userGUID, memberGUID, counter)
                            else
                              IO.puts "\nAn update is currently unavailable. Please try again tomorrow and contact support if unsuccessful after 3 days."
                              Agent.update(counter, fn x -> x - 3 end)
                            end
                          else
                            IO.puts code
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

  def readAggregationData(userGUID, memberGUID) do
    AtriumClient.readMember(userGUID, memberGUID)

    IO.puts "\n* Listing All Member Accounts *"
    accountsResponse = AtriumClient.listMemberAccounts(userGUID, memberGUID, "", "")
    {:ok, parsedJSON} = Poison.decode(to_string(accountsResponse))
    Enum.each(parsedJSON["accounts"], fn item ->
      IO.puts "Type: " <> to_string(item["type"]) <> "\tName: " <> to_string(item["name"]) <> "\tAvailable Balance: " <> to_string(item["available_balance"]) <> "\tAvailable Credit: " <> to_string(item["available_credit"])
    end)

    IO.puts "\n* Listing All Member Transactions *"
    transactionsResponse = AtriumClient.listMemberTransactions(userGUID, memberGUID, "", "", "", "")
    {:ok, parsedJSON} = Poison.decode(to_string(transactionsResponse))
    Enum.each(parsedJSON["transactions"], fn item ->
      IO.puts "Date: " <> to_string(item["date"]) <> "\tDescription: " <> to_string(item["description"]) <> "\tAmount: " <> to_string(item["amount"])
    end)
  end


  def start(_type, _args) do
    #main
    {:ok, counter} = Agent.start_link fn -> 0 end

    userGUID = String.trim(IO.gets("Please enter in user GUID. If not yet created just press enter key: "))
    memberGUID = String.trim(IO.gets("\nPlease enter in member GUID. If not yet created just press enter key: "))
    endUserPresent = String.trim(IO.gets("\nPlease enter in if end user is present (true or false): "))

    if (userGUID == "") and (memberGUID != "") do
      IO.puts "\nMust include user GUID when member GUID is entered."
      System.halt(0)
    end

    userGUID = if (userGUID == "") and (endUserPresent == "true") do
      IO.puts "\n* NEW USER CREATION *"

      identifier = String.trim(IO.gets("\nPlease enter in an unique id: "))

      userResponse = AtriumClient.createUser(identifier, "", "")

      {:ok, parsedJSON} = Poison.decode(to_string(userResponse))
      to_string(parsedJSON["user"]["guid"])
    else
      userGUID
    end

    if (memberGUID != "") and (endUserPresent == "true") do
      AtriumClient.aggregateMember(userGUID, memberGUID)
      checkJobStatus(userGUID, memberGUID, counter)
    else
      if memberGUID != "" do
        readAggregationData(userGUID, memberGUID)
      else
        if endUserPresent == "true" do
          IO.puts "\n* NEW MEMBER CREATION *"

          institution = String.trim(IO.gets("Please enter in a keyword to search for an institution: "))
          institutions = AtriumClient.listInstitutions(institution, "", "")

          {:ok, parsedJSON} = Poison.decode(to_string(institutions))
          Enum.each(parsedJSON["institutions"], fn item ->
            IO.puts to_string(item["name"]) <> " : institution code = " <> to_string(item["code"])
          end)

          institutionCode = String.trim(IO.gets("\nPlease enter in desired institution code: "))

          requiredCredentials = AtriumClient.readInstitutionCredentials(institutionCode, "", "")

          {:ok, parsedJSON} = Poison.decode(to_string(requiredCredentials))

          {:ok, credentials} = Agent.start_link fn -> [] end
          Enum.each(parsedJSON["credentials"], fn item ->
            cred = String.trim(IO.gets("\nPlease enter in " <> to_string(item["label"]) <> ": "))
            Agent.update(credentials, fn list -> [%{guid: item["guid"], value: cred} | list] end)
          end)

          creds = Agent.get(credentials, fn list -> list end)

          memberResponse = AtriumClient.createMember(userGUID, creds, institutionCode, "", "")

          {:ok, parsedJSON} = Poison.decode(to_string(memberResponse))
          memberGUID = to_string(parsedJSON["member"]["guid"])
          checkJobStatus(userGUID, memberGUID, counter)
        else
          IO.puts "\nEnd user must be present to create a new member"
          System.halt(0)
        end
      end
    end
  end
end
