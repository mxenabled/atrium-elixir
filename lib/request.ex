defmodule Atrium.Request do
  @moduledoc """
  Functions that allow you to create an HTTP request to Atrium
  """

  alias Atrium.Response

  @doc """
  Required Parameters: mode, endpoint, body
  Optional Parameters: None
  """
  def make_request(mode, endpoint, body) do
    url = Atrium.base_url() <> endpoint
    headers = generate_headers()
    make_request(mode, url, body, headers)
  end

  def optional_parameters(opts) do
    opts
    |> Enum.filter(fn {k, v} ->
      not is_nil(v) and v != "" and k in [:name, :from_date, :to_date, :page, :records_per_page]
    end)
    |> Enum.reduce("?", fn {k, v}, acc -> "#{acc}#{k}=#{v}&" end)
    |> String.slice(0..-2)
  end

  defp generate_headers() do
    [
      {"Accept", "application/vnd.mx.atrium.v1<>json"},
      {"Content-Type", "application/json"},
      {"MX-API-Key", Atrium.api_key()},
      {"MX-Client-ID", Atrium.client_id()}
    ]
  end

  defp make_request(:get, url, _body, headers) do
    case HTTPoison.get(url, headers, timeout: 50_000, recv_timeout: 50_000) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        Response.parse_response_body(code, body)

      other ->
        other
    end
  end

  defp make_request(:post, url, body, headers) do
    case HTTPoison.post(url, body, headers, timeout: 50_000, recv_timeout: 50_000) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        Response.parse_response_body(code, body)

      other ->
        other
    end
  end

  defp make_request(:put, url, body, headers) do
    case HTTPoison.put(url, body, headers, timeout: 50_000, recv_timeout: 50_000) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        Response.parse_response_body(code, body)

      other ->
        other
    end
  end

  defp make_request(:delete, url, _body, headers) do
    case HTTPoison.delete(url, headers, timeout: 50_000, recv_timeout: 50_000) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        Response.parse_response_body(code, body)

      other ->
        other
    end
  end
end
