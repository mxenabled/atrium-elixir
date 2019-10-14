defmodule Atrium.Institutions do
  @moduledoc """
    Functions for interacting with the `institutions` endpoint of Atrium.
  """

  alias Atrium.{Request, Response}

  @doc """
  Required Parameters: institution_code
  Optional Parameters: None

  https://atrium.mx.com/docs#read-institution
  """
  @spec read_institution(String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def read_institution(institution_code) do
    url = "/institutions/" <> institution_code

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: institution_code
  Optional Parameters: None

  https://atrium.mx.com/docs#read-institution
  """
  @spec read_institution!(String.t()) :: Map.t() | {:error, String.t()}
  def read_institution!(institution_code) do
    url = "/institutions/" <> institution_code

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: None
  Optional Parameters: name, page, records_per_page

  https://atrium.mx.com/docs#list-institutions
  """
  @spec list_institutions(Keyword.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def list_institutions(options \\ []) do
    params = Request.optional_parameters(options)
    url = "/institutions" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: None
  Optional Parameters: name, page, records_per_page

  https://atrium.mx.com/docs#list-institutions
  """
  @spec list_institutions!(Keyword.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def list_institutions!(options \\ []) do
    params = Request.optional_parameters(options)
    url = "/institutions" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end

  @doc """
  Required Parameters: institution_code
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#read-institution-credentials
  """
  @spec read_institution_credentials(String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def read_institution_credentials(institution_code, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/institutions/" <> institution_code <> "/credentials" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response()
  end

  @doc """
  Required Parameters: institution_code
  Optional Parameters: page, records_per_page

  https://atrium.mx.com/docs#read-institution-credentials
  """
  @spec read_institution_credentials!(String.t(), Keyword.t()) ::
          {:ok, Map.t()} | {:error, String.t()}
  def read_institution_credentials!(institution_code, options \\ []) do
    params = Request.optional_parameters(options)
    url = "/institutions/" <> institution_code <> "/credentials" <> params

    Request.make_request(:get, url, "")
    |> Response.handle_response!()
  end
end
