use Mix.Config

# Configure your database
config :sobes_review, SobesReview.Repo,
  username: "postgres",
  password: "111",
  database: "sobes_review_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sobes_review, SobesReviewWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :app_vars,
  pdots_key: "SHpqtAfuqzuKAWpTvUw47fQ2o1cxmjKgEgvLJe9Jvqs"
