# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# BASE_URL
# Production: "https://atrium.mx.com/"
# Development: "https://vestibule.mx.com"

config :atrium,
  api_key: "YOUR_MX_API_KEY",
  client_id: "YOUR_MX_CLIENT_ID",
  base_url: "https://atrium.mx.com/"

import_config "#{Mix.env()}.exs"
