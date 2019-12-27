import Config

config :reviewgen, Review.Repo,
  database: "sobes_review_dev",
  username: "postgres",
  password: "111",
  hostname: "localhost",
  pool_size: 50,
  queue_target: 5000

  config :reviewgen, ecto_repos: [Review.Repo]
