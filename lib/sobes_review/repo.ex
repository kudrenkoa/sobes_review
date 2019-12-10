defmodule SobesReview.Repo do
  use Ecto.Repo,
    otp_app: :sobes_review,
    adapter: Ecto.Adapters.Postgres


  # def add_review(attrs) do
  #   attrs |> SobesReview.Review.changeset
  # end
end
