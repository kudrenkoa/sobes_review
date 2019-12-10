defmodule SobesReview.Repo do
  use Ecto.Repo,
    otp_app: :sobes_review,
    adapter: Ecto.Adapters.Postgres


  def add_review({:ok, attrs}) do
    SobesReview.Review.changeset(%SobesReview.Review{}, attrs)
    |> insert
  end
end
