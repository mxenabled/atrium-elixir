defmodule Atrium.Accounts do
  @moduledoc """
  Functions for interacting with the `accounts` endpoint of Atrium.
  """
  alias Atrium.{Request, Response}

  @doc """
  # Required Parameters: user_guid, account_guid
  # Optional Parameters: None

  https://atrium.mx.com/docs#read-an-account
  """
  @spec read_account(String.t(), String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def read_account(user_guid, account_guid) do
    url = "/users/" <> user_guid <> "/accounts/" <> account_guid

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  # Required Parameters: user_guid, account_guid
  # Optional Parameters: None

  https://atrium.mx.com/docs#read-an-account
  """
  @spec read_account!(String.t(), String.t()) :: Map.t() | {:error, String.t()}
  def read_account!(user_guid, account_guid) do
    url = "/users/" <> user_guid <> "/accounts/" <> account_guid

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-accounts-for-a-user
  """
  @spec list_accounts(String.t(), Keyword.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def list_accounts(user_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/accounts" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-accounts-for-a-user
  """
  @spec list_accounts!(String.t(), Keyword.t()) :: Map.t() | {:error, String.t()}
  def list_accounts!(user_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/accounts" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, account_guid
  Optional Parameters: from_date, to_date, page, records_per_page

  https://atrium.mx.com/docs#list-account-transactions
  """
  @spec list_account_transactions(String.t(), String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def list_account_transactions(user_guid, account_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/accounts/" <> account_guid <> "/transactions" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, account_guid
  Optional Parameters: from_date, to_date, page, records_per_page

  https://atrium.mx.com/docs#list-account-transactions
  """
  @spec list_account_transactions!(String.t(), String.t(), Keyword.t()) ::
          Map.t() | {:error, String.t()}
  def list_account_transactions!(user_guid, account_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/accounts/" <> account_guid <> "/transactions" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, account_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-account-numbers
  """
  @spec list_account_account_numbers(String.t(), String.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def list_account_account_numbers(user_guid, account_guid) do
    url = "/users/" <> user_guid <> "/accounts/" <> account_guid <> "/account_numbers"

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, account_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-account-numbers
  """
  @spec list_account_account_numbers!(String.t(), String.t()) ::
          Map.t() | {:error, String.t()}
  def list_account_account_numbers!(user_guid, account_guid) do
    url = "/users/" <> user_guid <> "/accounts/" <> account_guid <> "/account_numbers"

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, account_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-account-numbers
  """
  @spec list_member_account_numbers(String.t(), String.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def list_member_account_numbers(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/account_numbers"

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, account_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-account-numbers
  """
  @spec list_member_account_numbers!(String.t(), String.t()) ::
          Map.t() | {:error, String.t()}
  def list_member_account_numbers!(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/account_numbers"

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#identity
  """
  @spec list_member_account_owners(String.t(), String.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def list_member_account_owners(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/account_owners"

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, member_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#identity
  """
  @spec list_member_account_owners!(String.t(), String.t()) ::
          Map.t() | {:error, String.t()}
  def list_member_account_owners!(user_guid, member_guid) do
    url = "/users/" <> user_guid <> "/members/" <> member_guid <> "/account_owners"

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end
end
