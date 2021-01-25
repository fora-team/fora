use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :fora, Fora.Repo,
  username: "postgres",
  password: "postgres",
  database: "fora_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fora, ForaWeb.Endpoint,
  http: [port: 4002],
  server: false

config :fora, Oban, crontab: false, queues: false, plugins: false

# Print only warnings and errors during test
config :logger, level: :warn

config :fora, Fora.Mailer, adapter: Bamboo.TestAdapter
