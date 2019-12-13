defmodule SobesReview.Repo do
  import Ecto.Query, only: [from: 2]
  alias Ecto.Changeset
  alias SobesReview.{Emotion, Review, City}

  use Ecto.Repo,
    otp_app: :sobes_review,
    adapter: Ecto.Adapters.Postgres

  def add_review({:ok, attrs, emotion}) do

    # IN DEV

    # emotion = one(from e in Emotion, where: e.name == ^emotion)
    # city = get_city(attrs.city)

    # case get_city(attrs.city) do
    #   nil -> insert_city(attrs.city)
    #   res -> res
    # end
    # %Review{}
    # |> Review.changeset(attrs)
    # |> insert
    # |> update_review_fks(emotion, city)
    # |> check_review_insert
  end

  def add_review({:error, _} = error) do
    error
  end

  defp update_review_fks({:ok, review = %Review{}}, emotion, city) do
    review
    |> preload(:emotion)
    |> preload(:city)
    |> Changeset.change
    |> Changeset.put_assoc(:emotion, emotion)
    |> Changeset.put_assoc(:city, city)
    |> update
  end

  def insert_city(city) do
    %City{}
    |> City.changeset(%{name: city})
    |> insert
  end

  def get_city(city) do
    one(from c in City, where: c.name == ^city)
  end

  defp update_review_fks({:error, _data} = err, _emotion, _city) do
    err
  end

  defp check_review_insert({:ok, _} = res) do
    res
  end

  defp check_review_insert({:error, handler}) do
    {:error, SobesReview.RepoErrorConverter.convert(handler.errors)}
  end


end
