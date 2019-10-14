defmodule Atrium.Merchants do
  @moduledoc """
  Functions for interacting with the `merchants` endpoint of Atrium.
  """
  alias Atrium.{Request, Response}

  @doc """
  Required Parameters: merchant_guid
  Optional Parameters: none

  https://atrium.mx.com/docs?shell#read-merchant
  """
  @spec read_merchant(String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def read_merchant(merchant_guid) when is_binary(merchant_guid) do
    url = "/merchants/#{merchant_guid}"

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: merchant_guid
  Optional Parameters: none

  https://atrium.mx.com/docs?shell#read-merchant
  """
  @spec read_merchant!(String.t()) :: Map.t() | {:error, String.t()}
  def read_merchant!(merchant_guid) when is_binary(merchant_guid) do
    url = "/merchants/#{merchant_guid}"

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end
end
