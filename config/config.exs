# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fora,
  ecto_repos: [Fora.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :fora, ForaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UAxxeHncjNKSeKQpmup7ODwF23r0Z6ftu4mLVVYznYkl0egiL8NI0ZuII+ANkq8K",
  render_errors: [view: ForaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Fora.PubSub,
  live_view: [signing_salt: "vnu/cpuT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :fora, Oban,
  repo: Fora.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, mail_delivery: 3]

config :fora, Fora.Kontos, send_invite_admin: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
