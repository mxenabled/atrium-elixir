defmodule Atrium.Members do
  @moduledoc """
  Functions for interacting with the `members` endpoint of Atrium.
  """
  alias Atrium.{Request, Response}

  @doc """
  Required Parameters: user_guid, credentials, institution_code
  Optional Parameters: identifier, metadata

  https://atrium.mx.com/docs#create-member
  """
  @spec create_member(String.t(), Map.t(), String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def create_member(user_guid, credentials, institution_code, options \\ []) do
    data =
      options
      |> Enum.filter(fn {_k, v} -> not is_nil(v) end)
      |> Enum.into(%{})
      |> Map.put(:institution_code, institution_code)
      |> Map.put(:credentials, credentials)

    body = Poison.encode!(%{member: data})
    url = "/users/" <> user_guid <> "/members"

    Request.make_request(:post, url, body)
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, credentials, institution_code
  Optional Parameters: identifier, metadata

  https://atrium.mx.com/docs#create-member
  """
  @spec create_member!(String.t(), Map.t(), String.t(), Keyword.t()) ::
          Map.t() | {:error, String.t()}
  def create_member!(user_guid, credentials, institution_code, options \\ []) do
    data =
      options
      |> Enum.filter(fn {_k, v} -> not is_nil(v) end)
      |> Enum.into(%{})
      |> Map.put(:institution_code, institution_code)
      |> Map.put(:credentials, credentials)

    body = Poison.encode!(%{member: data})

    url = "/users/" <> user_guid <> "/members"

    Request.make_request(:post, url, body)
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-member
  """
  @spec read_member(String.t(), String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def read_member(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-member
  """
  @spec read_member!(String.t(), String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def read_member!(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: credentials, identifier, metadata

  https://atrium.mx.com/docs#update-member
  """
  @spec update_member(String.t(), String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def update_member(user_guid, member_guid, options \\ []) do
    data =
      options
      |> Enum.filter(fn {_k, v} -> not is_nil(v) end)
      |> Enum.into(%{})

    body = Poison.encode!(%{member: data})
    url = "/users/" <> user_guid <> "/members/" <> member_guid

    Request.make_request(:put, url, body)
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: credentials, identifier, metadata

  https://atrium.mx.com/docs#update-member
  """
  @spec update_member!(String.t(), String.t(), Keyword.t()) ::
          Map.t() | {:error, String.t()}
  def update_member!(user_guid, member_guid, options \\ []) do
    data =
      options
      |> Enum.filter(fn {_k, v} -> not is_nil(v) end)
      |> Enum.into(%{})

    body = Poison.encode!(%{member: data})

    url = "/users/" <> user_guid <> "/members/" <> member_guid

    Request.make_request(:put, url, body)
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#delete-member
  """
  @spec delete_member(String.t(), String.t()) ::
          {:ok, String.t()} | {:error, String.t()}
  def delete_member(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid

    Request.make_request(:delete, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-members
  """
  @spec list_members(String.t(), Keyword.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def list_members(user_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/members" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-members
  """
  @spec list_members!(String.t(), Keyword.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def list_members!(user_guid, options \\ []) do
    params = Request.optional_parameters(options)

    url = "/users/" <> user_guid <> "/members" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#aggregate-member
  """
  @spec aggregate_member(String.t(), String.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def aggregate_member(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/aggregate"

    Request.make_request(:post, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#aggregate-member
  """
  @spec aggregate_member!(String.t(), String.t()) ::
          Map.t() | {:error, String.t()}
  def aggregate_member!(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/aggregate"

    Request.make_request(:post, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters:  user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-member-connection-status
  """
  @spec read_member_connection_status(String.t(), String.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def read_member_connection_status(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/status"

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters:  user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-member-connection-status
  """
  @spec read_member_connection_status!(String.t(), String.t()) ::
          Map.t() | {:error, String.t()}
  def read_member_connection_status!(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/status"

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-member-mfa-challenges
  """
  @spec list_member_mfa_challenges(String.t(), String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def list_member_mfa_challenges(user_guid, member_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/challenges" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-member-mfa-challenges
  """
  @spec list_member_mfa_challenges!(String.t(), String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def list_member_mfa_challenges!(user_guid, member_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/challenges" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid, answersMFA
  Optional Parameters: None

  https://atrium.mx.com/docs#resume-aggregation-from-mfa
  """
  @spec resume_member_aggregate(String.t(), String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def resume_member_aggregate(user_guid, member_guid, answers) do
    data = %{member: %{challenges: answers}}
    body = Poison.encode!(data)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/resume"

    Request.make_request(:put, url, body)
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid, answersMFA
  Optional Parameters: None

  https://atrium.mx.com/docs#resume-aggregation-from-mfa
  """
  @spec resume_member_aggregate!(String.t(), String.t(), Keyword.t()) ::
          Map.t() | {:error, String.t()}
  def resume_member_aggregate!(user_guid, member_guid, answers) do
    data = %{member: %{challenges: answers}}
    body = Poison.encode!(data)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/resume"

    Request.make_request(:put, url, body)
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-member-credentials
  """
  @spec list_member_credentials(String.t(), String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def list_member_credentials(user_guid, member_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/credentials" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-member-credentials
  """
  @spec list_member_credentials!(String.t(), String.t(), Keyword.t()) ::
          Map.t() | {:error, String.t()}
  def list_member_credentials!(user_guid, member_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/credentials" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-member-accounts
  """
  @spec list_member_accounts(String.t(), String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def list_member_accounts(user_guid, member_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/accounts" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-member-accounts
  """
  @spec list_member_accounts!(String.t(), String.t(), Keyword.t()) ::
          Map.t() | {:error, String.t()}
  def list_member_accounts!(user_guid, member_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/accounts" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: from_date, to_date, page, records_per_page

  https://atrium.mx.com/docs#list-member-transactions
  """
  @spec list_member_transactions(String.t(), String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def list_member_transactions(user_guid, member_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/transactions" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: from_date, to_date, page, records_per_page

  https://atrium.mx.com/docs#list-member-transactions
  """
  @spec list_member_transactions!(String.t(), String.t(), Keyword.t()) ::
          Map.t() | {:error, String.t()}
  def list_member_transactions!(user_guid, member_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/transactions" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#verify
  """
  @spec verify_member(String.t(), String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def verify_member(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/verify"

    Request.make_request(:post, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#verify
  """
  @spec verify_member!(String.t(), String.t()) :: Map.t() | {:error, String.t()}
  def verify_member!(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/verify"

    Request.make_request(:post, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#identify
  """
  @spec identify_member(String.t(), String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def identify_member(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/identify"

    Request.make_request(:post, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#identify
  """
  @spec identify_member!(String.t(), String.t()) :: Map.t() | {:error, String.t()}
  def identify_member!(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/identify"

    Request.make_request(:post, url, "")
    |> Response.handle_response!()
  end
end
