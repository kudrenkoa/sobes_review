defmodule Review.Repo do
  use Ecto.Repo,
    otp_app: :reviewgen,
    adapter: Ecto.Adapters.Postgres
end
