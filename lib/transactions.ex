defmodule Atrium.Transactions do
  @moduledoc """
  Functions that allow you to interact with the transaction atrium endpoint
  """

  alias Atrium.{Request, Response}

  @doc """
  Required Parameters: user_guid, transaction_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-a-transaction
  """
  @spec read_transaction(String.t(), String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def read_transaction(user_guid, transaction_guid) do
    url = "/users/" <> user_guid <> "/transactions/" <> transaction_guid

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid, transaction_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-a-transaction
  """
  @spec read_transaction!(String.t(), String.t()) :: Map.t() | {:error, String.t()}
  def read_transaction!(user_guid, transaction_guid) do
    url = "/users/" <> user_guid <> "/transactions/" <> transaction_guid

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid
  Optional Parameters: from_date, to_date, page, records_per_page

  https://atrium.mx.com/docs#list-transactions
  """
  @spec list_transactions(String.t(), Keyword.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def list_transactions(user_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/transactions" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid
  Optional Parameters: from_date, to_date, page, records_per_page

  https://atrium.mx.com/docs#list-transactions
  """
  @spec list_transactions!(String.t(), Keyword.t()) :: Map.t() | {:error, String.t()}
  def list_transactions!(user_guid, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users/" <> user_guid <> "/transactions" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: transactions_list
  Optional Parameters: none

  https://atrium.mx.com/docs#categorize-transactions
  """
  @spec categorize_and_describe_transactions(list(Map.t())) ::
          {:ok, Map.t()} | {:error, String.t()}
  def categorize_and_describe_transactions(transactions) do
    body = Poison.encode!(transactions)
    url = "/transactions/cleanse_and_categorize"

    Request.make_request(:post, url, body)
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: transactions_list
  Optional Parameters: none

  https://atrium.mx.com/docs#categorize-transactions
  """
  @spec categorize_and_describe_transactions!(list(Map.t())) ::
          Map.t() | {:error, String.t()}
  def categorize_and_describe_transactions!(transactions) do
    body = Poison.encode!(transactions)
    url = "/transactions/cleanse_and_categorize"

    Request.make_request(:post, url, body)
    |> Response.handle_response!()
  end
end
