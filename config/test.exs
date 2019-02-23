use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :slasher, SlasherWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :slasher, Slasher.Repo,
  username: "postgres",
  password: "clemer",
  database: "slasher_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
