defmodule AtriumClient do
  @mxAPIKEY "YOUR_MX_API_KEY"
  @mxCLIENTID "YOUR_MX_CLIENT_ID"
  @environment "ENVIRONMENT"

  # USER


  # Required Parameters: None
  # Optional Parameters: identifier, isDisabled, metadata
  def createUser(identifier, isDisabled, metadata) do
    data = %{user: %{identifier: identifier, is_disabled: isDisabled, metadata: metadata}}
    body = Poison.encode!(data)

    makeRequest("POST", "/users", body)
  end

  # Required Parameters: userGUID
  # Optional Parameters: None
  def readUser(userGUID) do
    makeRequest("GET", "/users/" <> userGUID, "")
  end

  # Required Parameters: None
  # Optional Parameters: userGUID, identifier, isDisabled, metadata
  def updateUser(userGUID, identifier, isDisabled, metadata) do
    data = %{user: %{identifier: identifier, is_disabled: isDisabled, metadata: metadata}}
    body = Poison.encode!(data)

    makeRequest("PUT", "/users/" <> userGUID, body)
  end

  # Required Parameters: None
  # Optional Parameters: pageNumber, recordsPerPage
  def listUsers(pageNumber, recordsPerPage) do
    params = optionalParameters("", "", "", pageNumber, recordsPerPage)

    makeRequest("GET", "/users" <> params, "")
  end

  def deleteUser(userGUID) do
    makeRequest("DELETE", "/users/" <> userGUID, "")
  end


  # INSTITUTION


  # Required Parameters: None
  # Optional Parameters: name, pageNumber, recordsPerPage
  def listInstitutions(name, pageNumber, recordsPerPage) do
    params = optionalParameters(name, "", "", pageNumber, recordsPerPage)

    makeRequest("GET", "/institutions" <> params, "")
  end

  # Required Parameters: institutionCode
  # Optional Parameters: None
  def readInstitution(institutionCode) do
    makeRequest("GET", "/institutions/" <> institutionCode, "")
  end

  # Required Parameters: institutionCode
  # Optional Parameters: pageNumber, recordsPerPage
  def readInstitutionCredentials(institutionCode, pageNumber, recordsPerPage) do
    params = optionalParameters("", "", "", pageNumber, recordsPerPage)

    makeRequest("GET", "/institutions/" <> institutionCode <> "/credentials" <> params, "")
  end


  # MEMBER


  # Required Parameters: userGUID, credentials, institutionCode
  # Optional Parameters: identifier, metadata
  def createMember(userGUID, credentials, institutionCode, identifier, metadata) do
    data = cond do
      (identifier != "") and (metadata != "") -> %{member: %{institution_code: institutionCode, credentials: credentials, identifier: identifier, metadata: metadata}}
      (identifier == "") and (metadata != "") -> %{member: %{institution_code: institutionCode, credentials: credentials, metadata: metadata}}
      (identifier != "") and (metadata == "") -> %{member: %{institution_code: institutionCode, credentials: credentials, identifier: identifier}}
      (identifier == "") and (metadata == "") -> %{member: %{institution_code: institutionCode, credentials: credentials}}
      true -> IO.puts "Error while creating member."
    end

    body = Poison.encode!(data)

    makeRequest("POST", "/users/" <> userGUID <> "/members", body)
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: None
  def readMember(userGUID, memberGUID) do
    makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID, "")
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: credentials, identifier, metadata
  def updateMember(userGUID, memberGUID, credentials, identifier, metadata) do
    data = cond do
      (credentials != "") and (identifier != "") and (metadata != "") -> %{member: %{credentials: credentials, identifier: identifier, metadata: metadata}}
      (credentials != "") and (identifier == "") and (metadata != "") -> %{member: %{credentials: credentials, metadata: metadata}}
      (credentials != "") and (identifier != "") and (metadata == "") -> %{member: %{credentials: credentials, identifier: identifier}}
      (credentials == "") and (identifier != "") and (metadata != "") -> %{member: %{identifier: identifier, metadata: metadata}}
      (credentials != "") and (identifier == "") and (metadata == "") -> %{member: %{credentials: credentials}}
      (credentials == "") and (identifier != "") and (metadata == "") -> %{member: %{identifier: identifier}}
      (credentials == "") and (identifier == "") and (metadata != "") -> %{member: %{metadata: metadata}}
      true -> IO.puts "Error while updating member."
    end

    body = Poison.encode!(data)

    makeRequest("PUT", "/users/" <> userGUID <> "/members/" <> memberGUID, body)
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: None
  def deleteMember(userGUID, memberGUID) do
    makeRequest("DELETE", "/users/" <> userGUID <> "/members/" <> memberGUID, "")
  end

  # Required Parameters: userGUID
  # Optional Parameters: pageNumber, recordsPerPage
  def listMembers(userGUID, pageNumber, recordsPerPage) do
    params = optionalParameters("", "", "", pageNumber, recordsPerPage)

    makeRequest("GET", "/users/" <> userGUID <> "/members" <> params, "")
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: None
  def aggregateMember(userGUID, memberGUID) do
    makeRequest("POST", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/aggregate", "")
  end

  # Required Parameters:  userGUID, memberGUID
  # Optional Parameters: None
  def readMemberAggregationStatus(userGUID, memberGUID) do
    makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/status", "")
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: pageNumber, recordsPerPage
  def listMemberMFAChallenges(userGUID, memberGUID, pageNumber, recordsPerPage) do
    params = optionalParameters("", "", "", pageNumber, recordsPerPage)

    makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/challenges" <> params, "")
  end

  # Required Parameters: userGUID, memberGUID, answersMFA
  # Optional Parameters: None
  def resumeMemberAggregation(userGUID, memberGUID, answers) do
    makeRequest("PUT", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/resume", answers)
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: pageNumber, recordsPerPage
  def listMemberCredentials(userGUID, memberGUID, pageNumber, recordsPerPage) do
    params = optionalParameters("", "", "", pageNumber, recordsPerPage)

    makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/credentials" <> params, "")
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: pageNumber, recordsPerPage
  def listMemberAccounts(userGUID, memberGUID, pageNumber, recordsPerPage) do
    params = optionalParameters("", "", "", pageNumber, recordsPerPage)

    makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/accounts" <> params, "")
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: fromDate, toDate, pageNumber, recordsPerPage
  def listMemberTransactions(userGUID, memberGUID, fromDate, toDate, pageNumber, recordsPerPage) do
    params = optionalParameters("", fromDate, toDate, pageNumber, recordsPerPage)

    makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/transactions" <> params, "")
  end


  # ACCOUNT

  # Required Parameters: userGUID, accountGUID
  # Optional Parameters: None
  def readAccount(userGUID, accountGUID) do
    makeRequest("GET", "/users/" <> userGUID <> "/accounts/" <> accountGUID, "")
  end

  # Required Parameters: userGUID
  # Optional Parameters: pageNumber, recordsPerPage
  def listAccounts(userGUID, pageNumber, recordsPerPage) do
    params = optionalParameters("", "", "", pageNumber, recordsPerPage)


    makeRequest("GET", "/users/" <> userGUID <> "/accounts" <> params, "")
  end

  # Required Parameters: userGUID, accountGUID
  # Optional Parameters: fromDate, toDate, pageNumber, recordsPerPage
  def listAccountTransactions(userGUID, accountGUID, fromDate, toDate, pageNumber, recordsPerPage) do
    params = optionalParameters("", fromDate, toDate, pageNumber, recordsPerPage)

    makeRequest("GET", "/users/" <> userGUID <> "/accounts/" <> accountGUID <> "/transactions" <> params, "")
  end


  # TRANSACTION

  # Required Parameters: userGUID, transactionGUID
  # Optional Parameters: None
  def readTransaction(userGUID, transactionGUID) do
    makeRequest("GET", "/users/" <> userGUID <> "/transactions/" <> transactionGUID, "")
  end

  # Required Parameters: userGUID
  # Optional Parameters: fromDate, toDate, pageNumber, recordsPerPage
  def listTransactions(userGUID, fromDate, toDate, pageNumber, recordsPerPage) do
    params = optionalParameters("", fromDate, toDate, pageNumber, recordsPerPage)

    makeRequest("GET", "/users/" <> userGUID <> "transactions" <> params, "")
  end


  # CONNECT WIDGET

  # Required Parameters: userGUID
  # Optional Parameters: None
  def createWidget(userGUID) do
    makeRequest("POST", "/users/" <> userGUID <> "/connect_widget_url", "")
  end


  # CLIENT

  # Required Parameters: mode, endpoint, body
  # Optional Parameters: None
  defp makeRequest(mode, endpoint, body) do
    Application.get_env(:atrium_ex, :api_key)
    url = @environment <> endpoint
    headers = [{ "Accept", "application/vnd.mx.atrium.v1<>json"}, {"Content-Type", "application/json"}, {"MX-API-Key", @mxAPIKEY }, {"MX-Client-ID", @mxCLIENTID }]

    if (mode == "GET") do
      case HTTPoison.get(url, headers, [timeout: 50_000, recv_timeout: 50_000]) do
        {:ok, %HTTPoison.Response{status_code: code, body: body}} -> httpError(code, body)
        other -> other
      end
    else
      if (mode == "POST") do
        case HTTPoison.post(url, body, headers, [timeout: 50_000, recv_timeout: 50_000]) do
          {:ok, %HTTPoison.Response{status_code: code, body: body}} -> httpError(code, body)
          other -> other
        end
      else
        if (mode == "PUT") do
          case HTTPoison.put(url, body, headers, [timeout: 50_000, recv_timeout: 50_000]) do
            {:ok, %HTTPoison.Response{status_code: code, body: body}} -> httpError(code, body)
            other -> other
          end
        else
          if (mode == "DELETE") do
            case HTTPoison.delete(url, headers, [timeout: 50_000, recv_timeout: 50_000]) do
              {:ok, %HTTPoison.Response{status_code: code, body: body}} -> httpError(code, body)
              other -> other
            end
          end
        end
      end
    end
  end

  # Print and exit on http error
  defp httpError(status_code, body) do
    case {status_code} do
      {400} -> IO.puts(to_string(status_code) <> " error: Required parameter is missing.")
      {401} -> IO.puts(to_string(status_code) <> " error: Invalid MX-API-Key, MX-Client-ID, or being used in wrong environment.")
      {403} -> IO.puts(to_string(status_code) <> " error: Requests must be HTTPS.")
      {404} -> IO.puts(to_string(status_code) <> " error: GUID / URL path not recognized.")
      {405} -> IO.puts(to_string(status_code) <> " error: Endpoint constraint not met.")
      {406} -> IO.puts(to_string(status_code) <> " error: Specifiy valid API version.")
      {409} -> IO.puts(to_string(status_code) <> " error: Object already exists.")
      {422} -> IO.puts(to_string(status_code) <> " error: Data provided cannot be processed.")
      {500} -> IO.puts(to_string(status_code) <> " error: An unexpected error occurred on MX's systems.")
      {502} -> IO.puts(to_string(status_code) <> " error: An unexpected error occurred on MX's systems.")
      {504} -> IO.puts(to_string(status_code) <> " error: An unexpected error occurred on MX's systems.")
      {503} -> IO.puts(to_string(status_code) <> " error: Please try again later. The MX Platform is currently being updated.")
      {_} -> body
    end

    if (div(status_code, 100) == 4 ) or (div(status_code, 100) == 5) do
      System.halt(0)
    end

    # return body
    body
  end

  defp optionalParameters(name, fromDate, toDate, pageNumber, recordsPerPage) do
    params = "?"
    params = if (name != "") do
      params <> "name=" <> name <> "&"
    else
      params
    end
    params = if (fromDate != "") do
      params <> "from_date=" <> fromDate <> "&"
    else
      params
    end
    params = if (toDate != "") do
      params <> "to_date=" <> toDate <> "&"
    else
      params
    end
    params = if (pageNumber != "") do
      params <> "page=" <> pageNumber <> "&"
    else
      params
    end
    params = if (recordsPerPage != "") do
      params <> "records_per_page=" <> recordsPerPage <> "&"
    else
      params
    end
    String.slice(params, 0..-2)
  end
end
