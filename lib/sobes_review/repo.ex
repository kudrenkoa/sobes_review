defmodule SobesReview.Repo do
  import Ecto.Query, only: [from: 2]
  alias Ecto.Changeset
  alias SobesReview.{Emotion, Review}

  use Ecto.Repo,
    otp_app: :sobes_review,
    adapter: Ecto.Adapters.Postgres

  def add_review({:ok, attrs, emotion}) do
    %Review{}
    |> Review.changeset(attrs)
    |> insert
    |> asoc_review_emotion(emotion)
    |> update
    |> check_review_insert
  end

  defp asoc_review_emotion({:ok, review = %Review{}}, emotion) do
    get_emotion_query = one(from e in Emotion, where: e.name == ^emotion)
    review
    |> preload(:emotion)
    |> Changeset.change
    |> Changeset.put_assoc(:emotion, get_emotion_query)
  end

  defp asoc_review_emotion({:error, _handler} = error, _emotion) do
    error
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
end
