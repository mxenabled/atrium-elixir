# Atrium-Elixir

An Elixir wrapper for the [MX Atrium API](https://atrium.mx.com). In order to make requests, you will need to [sign up for the MX Atrium API](https://atrium.mx.com/developers/sign_up) and get a `MX-API-KEY` and a `MX-CLIENT-ID`.

## Usage

There are two ways to utilize this library:

### Inside the library itself.

I would not recommend doing it like this as you will save your api keys inside the repo.

First, navigate to the `/config` directory of `Atrium-Elixir` and open up `config.exs` to configure your instance:

```elixir
config :atrium,
  api_key: "YOUR_MX_API_KEY",
  client_id: "YOUR_MX_CLIENT_ID",
  base_url: "BASE_URL"
```

If you want to test out the library using IEx or the unit tests, then you will need to configure the `dev.exs` and the `test.exs` config files in the same way as you did the `config.exs`.

(The `BASE_URL` will be either `https://vestibule.mx.com` for the development environment or `https://atrium.mx.com` for the production environment.)

Next, run `mix deps.get` to get the required dependencies.

From there you can start using methods to make calls to the Atrium API for data. See the full [Atrium documentation](https://atrium.mx.com/documentation) for more details.

You can then self-host this library and pull it into your application as a dependency from your appropriate repo provider.

### Injecting the API KEYS into the library from Application startup (Recommended)

Instead of saving your api keys inside the library and storing them in the repo, please insert the keys into the library when your application starts up

Example:

- .env file:

  ```
  MX_ATRIUM_API_KEY=YOUR_MX_API_KEY
  MX_ATRIUM_CLIENT_ID=YOUR_MX_CLIENT_ID
  MX_ATRIUM_BASE_URL=BASE_URL
  ```

- Then, using the Confex library to pull the env variables in during runtime instead of during compilation, you have lines similar to this in one of your config files:

  ```
  ## MX Atrium API variables
  config :core, :mx_atrium_api_key, {:system, :string, "MX_ATRIUM_API_KEY"}
  config :core, :mx_atrium_client_id, {:system, :string, "MX_ATRIUM_CLIENT_ID"}
  config :core, :mx_atrium_base_url, {:system, :string, "MX_ATRIUM_BASE_URL"}
  ```

- Inside the `start/2` function in the `application.ex` module

  ```
  def start(_type, _args) do
    children = [ ]

    # If you use confex to inject them during runtime, use this method. You can alternatively use `Application.get_env`
    Application.put_env(:atrium, :api_key, Confex.get_env(:core, :mx_atrium_api_key))
    Application.put_env(:atrium, :client_id, Confex.get_env(:core, :mx_atrium_client_id))
    Application.put_env(:atrium, :base_url, Confex.get_env(:core, :mx_atrium_base_url))

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
  ```

## Testing

### Unit tests

Run: `mix test`

The majority of the modules have sandbox unit tests that will not run unless specifically commanded to. They will then pass if you add the appropriate API and ClientID keys to the config files.

The Unit Tests are provided to show what the anticipated response is from the API. Use these as a reference on how to use the library

### Sandbox tests

These test are hitting the actual sandbox of Atrium/Vestibule. They will create / update / delete objects in your company so be sure to use a development API kety.

1. Run the test `mix test --only sandbox`

#### Why we have Sandbox tests?

In the best environment we should be using mock library and never hit the actual API, however during the development we found out that Atrium/Vestibue API is very often iterating quickly and returns something differently that you would expect. These Sandbox test which are hitting actual API helped us discover countless bugs we would not seen when doing mock.

Unit tests also provide an ideal way to receive pull requests when something is found to have changed.

## Examples

THESE ARE MOST LIKELY OUT DATED. USE THEM AS REFERENCE, BUT NOT LAW THE UNIT TESTS SHOULD BE USED AS REFERENCE FOR WHAT IS RETURNED FROM THE API.

The `/examples` directory contains various workflows and code snippets. An example can be run by:

1. running `iex -S mix`
2. Running `Atrium.Examples.[MODULE].run_example()`
