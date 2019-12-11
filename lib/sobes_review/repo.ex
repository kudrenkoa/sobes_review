defmodule SobesReview.Repo do
  import Ecto.Query, only: [from: 2]
  use Ecto.Repo,
    otp_app: :sobes_review,
    adapter: Ecto.Adapters.Postgres


  def add_review({:ok, attrs}) do
    SobesReview.Review.changeset(%SobesReview.Review{}, attrs)
    |> insert
  end

  def add_review(err) do
    err
  end

  def get_review_count() do
    one(from c in SobesReview.Counter, where: c.name == "review", select: c.value)
  end
end
