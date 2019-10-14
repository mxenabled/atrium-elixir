# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Change these to the Development API key and ClientID
# you receive https://atrium.mx.com/api_keys
# This will allow the tests to pass and verify that the endpoints are working

config :atrium,
  api_key: "YOUR_MX_API_KEY",
  client_id: "YOUR_MX_CLIENT_ID",
  base_url: "https://vestibule.mx.com"
