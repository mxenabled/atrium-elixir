defmodule Atrium do
  @mxAPIKEY "2f86c113535c59e19ccf5022e2fdfc284541fdba"
  @mxCLIENTID "8981eb0a-84c6-49d9-930a-c343e6cff7df"
  @environment "https://vestibule.mx.com"

  # USER


  # Required Parameters: None
  # Optional Parameters: identifier, is_disabled, metadata
  def createUser(options \\ []) do
    defaults = [identifier: nil, is_disabled: nil, metadata: nil]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{identifier: identifier, is_disabled: is_disabled, metadata: metadata} = options

    data = %{user: %{identifier: identifier, is_disabled: is_disabled, metadata: metadata}}
    body = Poison.encode!(data)

    response = makeRequest("POST", "/users", body)
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["user"]
  end

  # Required Parameters: userGUID
  # Optional Parameters: None
  def readUser(userGUID) do
    response = makeRequest("GET", "/users/" <> userGUID, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["user"]
  end

  # Required Parameters: None
  # Optional Parameters: userGUID, identifier, is_disabled, metadata
  def updateUser(userGUID, options \\ []) do
    defaults = [identifier: nil, is_disabled: nil, metadata: nil]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{identifier: identifier, is_disabled: is_disabled, metadata: metadata} = options

    data = %{user: %{identifier: identifier, is_disabled: is_disabled, metadata: metadata}}
    body = Poison.encode!(data)

    response = makeRequest("PUT", "/users/" <> userGUID, body)
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["user"]
  end

  # Required Parameters: None
  # Optional Parameters: page, records_per_page
  def listUsers(options \\ []) do
    defaults = [page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", "", "", page, records_per_page)

    response = makeRequest("GET", "/users" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["users"]
  end

  def deleteUser(userGUID) do
    makeRequest("DELETE", "/users/" <> userGUID, "")
  end


  # INSTITUTION


  # Required Parameters: None
  # Optional Parameters: name, page, records_per_page
  def listInstitutions(options \\ []) do
    defaults = [name: "", page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{name: name, page: page, records_per_page: records_per_page} = options

    params = optionalParameters(name, "", "", page, records_per_page)

    response = makeRequest("GET", "/institutions" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["institutions"]
  end

  # Required Parameters: institutionCode
  # Optional Parameters: None
  def readInstitution(institutionCode) do
    response = makeRequest("GET", "/institutions/" <> institutionCode, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["institution"]
  end

  # Required Parameters: institutionCode
  # Optional Parameters: page, records_per_page
  def readInstitutionCredentials(institutionCode, options \\ []) do
    defaults = [page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", "", "", page, records_per_page)

    response = makeRequest("GET", "/institutions/" <> institutionCode <> "/credentials" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["credentials"]
  end


  # MEMBER


  # Required Parameters: userGUID, credentials, institutionCode
  # Optional Parameters: identifier, metadata
  def createMember(userGUID, credentials, institutionCode, options \\ []) do
    defaults = [identifier: nil, metadata: nil]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{identifier: identifier, metadata: metadata} = options

    data = cond do
      (identifier != nil) and (metadata != nil) -> %{member: %{institution_code: institutionCode, credentials: credentials, identifier: identifier, metadata: metadata}}
      (identifier == nil) and (metadata != nil) -> %{member: %{institution_code: institutionCode, credentials: credentials, metadata: metadata}}
      (identifier != nil) and (metadata == nil) -> %{member: %{institution_code: institutionCode, credentials: credentials, identifier: identifier}}
      (identifier == nil) and (metadata == nil) -> %{member: %{institution_code: institutionCode, credentials: credentials}}
      true -> IO.puts "Error while creating member."
    end

    body = Poison.encode!(data)

    response = makeRequest("POST", "/users/" <> userGUID <> "/members", body)
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["member"]
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: None
  def readMember(userGUID, memberGUID) do
    response = makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["member"]
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: credentials, identifier, metadata
  def updateMember(userGUID, memberGUID, options \\ []) do
    defaults = [credentials: nil, identifier: nil, metadata: nil]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{credentials: credentials, identifier: identifier, metadata: metadata} = options

    data = cond do
      (credentials != nil) and (identifier != nil) and (metadata != nil) -> %{member: %{credentials: credentials, identifier: identifier, metadata: metadata}}
      (credentials != nil) and (identifier == nil) and (metadata != nil) -> %{member: %{credentials: credentials, metadata: metadata}}
      (credentials != nil) and (identifier != nil) and (metadata == nil) -> %{member: %{credentials: credentials, identifier: identifier}}
      (credentials == nil) and (identifier != nil) and (metadata != nil) -> %{member: %{identifier: identifier, metadata: metadata}}
      (credentials != nil) and (identifier == nil) and (metadata == nil) -> %{member: %{credentials: credentials}}
      (credentials == nil) and (identifier != nil) and (metadata == nil) -> %{member: %{identifier: identifier}}
      (credentials == nil) and (identifier == nil) and (metadata != nil) -> %{member: %{metadata: metadata}}
      true -> IO.puts "Error while updating member."
    end

    body = Poison.encode!(data)

    response = makeRequest("PUT", "/users/" <> userGUID <> "/members/" <> memberGUID, body)
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["member"]
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: None
  def deleteMember(userGUID, memberGUID) do
    makeRequest("DELETE", "/users/" <> userGUID <> "/members/" <> memberGUID, "")
  end

  # Required Parameters: userGUID
  # Optional Parameters: page, records_per_page
  def listMembers(userGUID, options \\ []) do
    defaults = [page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", "", "", page, records_per_page)

    response = makeRequest("GET", "/users/" <> userGUID <> "/members" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["members"]
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: None
  def aggregateMember(userGUID, memberGUID) do
    response = makeRequest("POST", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/aggregate", "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["member"]
  end

  # Required Parameters:  userGUID, memberGUID
  # Optional Parameters: None
  def readMemberAggregationStatus(userGUID, memberGUID) do
    response = makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/status", "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["member"]
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: page, records_per_page
  def listMemberMFAChallenges(userGUID, memberGUID, options \\ []) do
    defaults = [page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", "", "", page, records_per_page)

    response = makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/challenges" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["challenges"]
  end

  # Required Parameters: userGUID, memberGUID, answersMFA
  # Optional Parameters: None
  def resumeMemberAggregation(userGUID, memberGUID, answers) do
    data = %{member: %{challenges: answers}}
    body = Poison.encode!(data)

    response = makeRequest("PUT", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/resume", body)
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["member"]
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: page, records_per_page
  def listMemberCredentials(userGUID, memberGUID, options \\ []) do
    defaults = [page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", "", "", page, records_per_page)

    response = makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/credentials" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["credentials"]
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: page, records_per_page
  def listMemberAccounts(userGUID, memberGUID, options \\ []) do
    defaults = [page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", "", "", page, records_per_page)

    response = makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/accounts" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["accounts"]
  end

  # Required Parameters: userGUID, memberGUID
  # Optional Parameters: from_date, to_date, page, records_per_page
  def listMemberTransactions(userGUID, memberGUID, options \\ []) do
    defaults = [from_date: "", to_date: "", page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{from_date: from_date, to_date: to_date, page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", from_date, to_date, page, records_per_page)

    response = makeRequest("GET", "/users/" <> userGUID <> "/members/" <> memberGUID <> "/transactions" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["transactions"]
  end


  # ACCOUNT

  # Required Parameters: userGUID, accountGUID
  # Optional Parameters: None
  def readAccount(userGUID, accountGUID) do
    response = makeRequest("GET", "/users/" <> userGUID <> "/accounts/" <> accountGUID, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["account"]
  end

  # Required Parameters: userGUID
  # Optional Parameters: page, records_per_page
  def listAccounts(userGUID, options \\ []) do
    defaults = [page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", "", "", page, records_per_page)

    response = makeRequest("GET", "/users/" <> userGUID <> "/accounts" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["accounts"]
  end

  # Required Parameters: userGUID, accountGUID
  # Optional Parameters: from_date, to_date, page, records_per_page
  def listAccountTransactions(userGUID, accountGUID, options \\ []) do
    defaults = [from_date: "", to_date: "", page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{from_date: from_date, to_date: to_date, page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", from_date, to_date, page, records_per_page)

    response = makeRequest("GET", "/users/" <> userGUID <> "/accounts/" <> accountGUID <> "/transactions" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["transactions"]
  end


  # TRANSACTION

  # Required Parameters: userGUID, transactionGUID
  # Optional Parameters: None
  def readTransaction(userGUID, transactionGUID) do
    response = makeRequest("GET", "/users/" <> userGUID <> "/transactions/" <> transactionGUID, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["transaction"]
  end

  # Required Parameters: userGUID
  # Optional Parameters: from_date, to_date, page, records_per_page
  def listTransactions(userGUID, options \\ []) do
    defaults = [from_date: "", to_date: "", page: "", records_per_page: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})
    %{from_date: from_date, to_date: to_date, page: page, records_per_page: records_per_page} = options

    params = optionalParameters("", from_date, to_date, page, records_per_page)

    response = makeRequest("GET", "/users/" <> userGUID <> "/transactions" <> params, "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["transactions"]
  end


  # CONNECT WIDGET

  # Required Parameters: userGUID
  # Optional Parameters: None
  def createWidget(userGUID) do
    response = makeRequest("POST", "/users/" <> userGUID <> "/connect_widget_url", "")
    {:ok, parsedJSON} = Poison.decode(to_string(response))
    parsedJSON["user"]
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

  defp optionalParameters(name, from_date, to_date, page, records_per_page) do
    params = "?"
    params = if (name != "") do
      params <> "name=" <> name <> "&"
    else
      params
    end
    params = if (from_date != "") do
      params <> "from_date=" <> from_date <> "&"
    else
      params
    end
    params = if (to_date != "") do
      params <> "to_date=" <> to_date <> "&"
    else
      params
    end
    params = if (page != "") do
      params <> "page=" <> page <> "&"
    else
      params
    end
    params = if (records_per_page != "") do
      params <> "records_per_page=" <> records_per_page <> "&"
    else
      params
    end
    String.slice(params, 0..-2)
  end
end
