defmodule Atrium.Users do
  @moduledoc """
  Functions for interacting with the `users` endpoint of Atrium.
  """
  alias Atrium.{Request, Response}

  @doc """
  Required Parameters: none
  Optional Parameters: options_list

  Optional Params include: identifier, is_disabled, metadata.
  None of these parameters are required, but the user object cannot be empty.

  https://atrium.mx.com/docs#create-user
  """
  @spec create_user(Keyword.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def create_user(options \\ []) do
    body = Poison.encode!(%{user: Enum.into(options, %{})})
    url = "/users"

    Request.make_request(:post, url, body)
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: none
  Optional Parameters: options_list []

  Optional Params include: identifier, is_disabled, metadata.
  None of these parameters are required, but the user object cannot be empty.

  https://atrium.mx.com/docs#create-user
  """
  @spec create_user!(Keyword.t()) :: Map.t() | {:error, String.t()}
  def create_user!(options \\ []) do
    body = Poison.encode!(%{user: Enum.into(options, %{})})
    url = "/users"

    Request.make_request(:post, url, body)
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-user
  """
  @spec read_user(String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def read_user(user_guid) do
    url = "/users/" <> user_guid

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: user_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#read-user
  """
  @spec read_user!(String.t()) :: Map.t() | {:error, String.t()}
  def read_user!(user_guid) do
    url = "/users/" <> user_guid

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: None
  Optional Parameters: user_guid, identifier, is_disabled, metadata

  Optional Params include: identifier, is_disabled, metadata.
  None of these parameters are required, but the user object cannot be empty.

  https://atrium.mx.com/docs#update-user
  """
  @spec update_user(String.t(), Keyword.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def update_user(user_guid, options \\ []) do
    body = Poison.encode!(%{user: Enum.into(options, %{})})
    url = "/users/" <> user_guid

    Request.make_request(:put, url, body)
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: None
  Optional Parameters: user_guid, identifier, is_disabled, metadata

  Optional Params include: identifier, is_disabled, metadata.
  None of these parameters are required, but the user object cannot be empty.

  https://atrium.mx.com/docs#update-user
  """
  @spec update_user!(String.t(), Keyword.t()) :: Map.t() | {:error, String.t()}
  def update_user!(user_guid, options \\ []) do
    body = Poison.encode!(%{user: Enum.into(options, %{})})

    url = "/users/" <> user_guid

    Request.make_request(:put, url, body)
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: user_guid

  Calling this endpoint will permanently delete a user from Atrium.
  If successful, the API will respond with Status: 204 No Content.

  https://atrium.mx.com/docs#delete-user
  """
  @spec delete_user(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def delete_user(user_guid) do
    url = "/users/" <> user_guid

    Request.make_request(:delete, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: None
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-users
  """
  @spec list_users(Keyword.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def list_users(options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: None
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#list-users
  """
  @spec list_users!(Keyword.t()) :: Map.t() | {:error, String.t()}
  def list_users!(options \\ []) do
    params = Request.optional_parameters(options)
    url = "/users" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end
end
