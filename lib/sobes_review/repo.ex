defmodule SobesReview.Repo do
  import Ecto.Query, only: [from: 2]
  use Ecto.Repo,
    otp_app: :sobes_review,
    adapter: Ecto.Adapters.Postgres


  def add_review({:ok, attrs, emotion}) do
    one(from e in SobesReview.Emotion, where: e.name == ^emotion)
    |> Ecto.build_assoc(:reviews, attrs)
    |> SobesReview.Review.changeset(attrs)
    |> insert
    |> check_review_insert
  end

  defp check_review_insert({:ok, _} = res) do
    res
  end

  defp check_review_insert({:error, handler}) do
    {:error, SobesReview.RepoErrorConverter.convert(handler.errors)}
  end

  def add_review(err) do
    err
  end

  def get_review_count() do
    one(from c in SobesReview.Counter, where: c.name == "review", select: c.value)
  end
end
