defmodule SobesReview.Repo do
  import Ecto.Query, only: [from: 2]
  alias SobesReview.{Emotion, Review, City, Review_City, Review_Emotion, Review_Gender, Review_Month, Review_Time}

  use Ecto.Repo,
    otp_app: :sobes_review,
    adapter: Ecto.Adapters.Postgres


  @spec get_all_cities :: list
  def get_all_cities() do
    all(City)
  end

  @spec get_reviews_count :: integer
  def get_reviews_count() do
    one(from r in SobesReview.Review, select: count(r))
  end

  def insert_review(attrs) do
    %Review{}
    |> Review.changeset(attrs)
    |> insert
    |> check_review_insert
  end

  def update_review_city(%Review{} = review, city_id) do
    attrs = %{city_id: city_id}
    review
    |> Review.changeset_city(attrs)
    |> update
  end

  def update_review_emotion(emotion_id, %Review{} = review) do
    attrs = %{emotion_id: emotion_id}
    review
    |> Review.changeset_emotion(attrs)
    |> update
  end

  def insert_city(city) do
    %City{}
    |> City.changeset(%{name: city})
    |> insert!
  end

  @spec get_city(binary) :: %Review{}
  def get_city(city) do
    one(from c in City, where: c.name == ^city)
  end

  @spec get_all_emotions :: list
  def get_all_emotions() do
    all(Emotion)
  end

  defp check_review_insert({:ok, _} = res) do
    res
  end

  defp check_review_insert({:error, handler}) do
    {:error, SobesReview.RepoErrorConverter.convert(handler.errors)}
  end

  @spec get_stream_review_all(:gender | :city | :emotion | :month | :month | :time) ::
          {:error, :undefined_view_type} | Stream.t()
  def get_stream_review_all(view_type) do
    view_type |>
    get_view_type
    |> case do
      {:error, _descr} = error -> error
      view -> stream(from r in view, select: r)
    end
  end

  defp get_view_type(d) do
    case d do
      :gender -> Review_Gender
      :city -> Review_City
      :emotion -> Review_Emotion
      :month -> Review_Month
      :time -> Review_Time
      _ -> {:error, :undefined_view_type}
    end
  end
end
