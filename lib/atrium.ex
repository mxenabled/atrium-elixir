defmodule Atrium do
  @moduledoc """
  API wrapper for the MX Atrium endpoint
  """

  def api_key, do: Application.get_env(:atrium, :api_key, "")
  def client_id, do: Application.get_env(:atrium, :client_id, "")
  def base_url, do: Application.get_env(:atrium, :base_url, "https://vestibule.mx.com")
end
