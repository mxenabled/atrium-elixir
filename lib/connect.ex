defmodule Atrium.Connect do
  @moduledoc """
  Functions that allow you to interact with the `connect_widget_url` atrium endpoint

  https://atrium.mx.com/docs#mx-connect-widget
  """

  alias Atrium.{Request, Response}

  @doc """
  Required Parameters: user_guid
  Optional Parameters: None

  https://atrium.mx.com/docs#mx-connect-widget
  """
  @spec create_widget(String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def create_widget(user_guid) do
    url = "/users/" <> user_guid <> "/connect_widget_url"

    Request.make_request(:post, url, "")
    |> Response.handle_response()
  end
end
