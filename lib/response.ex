defmodule Atrium.Response do
  @moduledoc """
  Functions that parse the HTTPoison.Reponse
  """

  @doc """
  https://atrium.mx.com/docs#errors

  On success: {:ok, body}
  On failure: {:error, message}
  """
  def parse_response_body(status_code, body) do
    case status_code do
      x when x in [200, 202, 204] ->
        {:ok, get_success_response(status_code, body)}

      _ ->
        {:error, get_status_code_message(status_code)}
    end
  end

  defp decode_response_body(body) do
    {:ok, parsed_json} = Atrium.JSON.decode(to_string(body))
    parsed_json
  end

  @doc """
  Takes the result of a Request.make_request.
  Returns either an {:ok, _ } or {:error, _} tuple
  """
  @spec handle_response({:ok, Map.t()} | {:error, String.t()}) ::
          {:ok, Map.t()} | {:error, String.t()}
  def handle_response(response) do
    case response do
      {:ok, _body} = success ->
        success

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Takes the result of a Request.make_request.
  Returns either an Map.t() or raises an error
  """
  @spec handle_response!({:ok, Map.t()} | {:error, String.t()}) ::
          Map.t() | no_return
  def handle_response!(response) do
    case response do
      {:ok, body} = _success ->
        body

      {:error, error} ->
        raise error
    end
  end

  # https://atrium.mx.com/docs#errors
  # Success
  defp get_success_response(200, body), do: decode_response_body(body)
  defp get_success_response(202, body), do: decode_response_body(body)
  defp get_success_response(204, _body), do: "204: No Content"

  # https://atrium.mx.com/docs#errors
  # Print on http error

  defp get_status_code_message(400 = code),
    do: "#{code} Bad Request: Often, this means a required parameter was missing."

  defp get_status_code_message(401 = code),
    do: "#{code} Unauthorized: Invalid MX-API-Key, MX-Client-ID, or used in wrong environment."

  defp get_status_code_message(403 = code),
    do: "#{code} Forbidden: The request was made from a non-whitelisted address."

  defp get_status_code_message(404 = code),
    do: "#{code} Not Found: GUID / URL path not recognized. Invalid item/id/URL requested."

  defp get_status_code_message(405 = code),
    do: "#{code} Method Not Allowed: A constraint on the requested endpoint wasn't met."

  defp get_status_code_message(406 = code),
    do: "#{code} Not Acceptable: The request didn't specify a valid API version."

  defp get_status_code_message(409 = code),
    do: "#{code} Conflict: An object with the given attributes already exists."

  defp get_status_code_message(422 = code),
    do: "#{code} Unprocessable Entity: The data provided cannot be processed."

  defp get_status_code_message(500 = code),
    do: "#{code} Server error: Something went wrong with MX's servers."

  defp get_status_code_message(502 = code),
    do: "#{code} Server error: Something went wrong with MX's servers."

  defp get_status_code_message(503 = code),
    do: "#{code} Service Unavailable: Please try again later. The MX Platform is being updated."

  defp get_status_code_message(504 = code),
    do: "#{code} Server error: Something went wrong with MX's servers."

  defp get_status_code_message(code), do: "#{code} error: An unplanned code was returned."
end
