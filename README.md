# Atrium-Elixir

An Elixir wrapper for the [MX Atrium API](https://atrium.mx.com). In order to make requests, you will need to [sign up for the MX Atrium API](https://atrium.mx.com/developers/sign_up) and get a `MX-API-KEY` and a  `MX-CLIENT-ID`.

### Usage

First, navigate to the `/config` directory and open up `config.exs` to configure your instance:
```elixir
config :atrium, api_key: "YOUR_MX_API_KEY",
                client_id: "YOUR_MX_CLIENT_ID",
                base_url: "BASE_URL"
```

(The `BASE_URL` will be either `https://vestibule.mx.com` for the development environment or `https://atrium.mx.com` for the production environment.)

Next, run `mix deps.get` to get the required dependencies.

From there you can start using methods to make calls to the Atrium API for data. See the full [Atrium documentation](https://atrium.mx.com/documentation) for more details.

### Examples

The `/examples` directory contains various workflows and code snippets. An example can be run by using `mix run examples/filename.exs`, substituting `filename.exs` with the name of the desired example.
