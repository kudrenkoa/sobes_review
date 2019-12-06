defmodule SobesReview.Repo do
  use Ecto.Repo,
    otp_app: :sobes_review,
    adapter: Ecto.Adapters.Postgres
end
