defmodule SobesReview.Repo do
  import Ecto.Query, only: [from: 2]
  alias SobesReview.{Emotion, Review, City, Review_City, Review_Emotion,
    Review_Gender, Review_Month, Review_Time}

  use Ecto.Repo,
    otp_app: :sobes_review,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Returns list of all %City{}
  """
  @spec get_all_cities :: list
  def get_all_cities() do
    all(City)
  end

  @doc """
  Returns count of all review in db
  """
  @spec get_reviews_count :: integer
  def get_reviews_count() do
    one(from r in SobesReview.Review, select: count(r))
  end

  @doc """
  Inserts new review by attrs into db. Returns {:ok, %Review{}} | {:error, description}
  """
  @spec insert_review(map) :: {:error, binary} | {:ok, any}
  def insert_review(attrs) do
    %Review{}
    |> Review.changeset(attrs)
    |> insert
    |> check_review_insert
  end

  @doc """
  Updates review with city_id. Returns {:ok, %Review{}} | {:error, description}
  """
  def update_review_city(%Review{} = review, city_id) do
    attrs = %{city_id: city_id}
    review
    |> Review.changeset_city(attrs)
    |> update
  end

  @doc """
  Updates review with emotion_id. Returns {:ok, %Review{}} | {:error, description}
  """
  def update_review_emotion(emotion_id, %Review{} = review) do
    attrs = %{emotion_id: emotion_id}
    review
    |> Review.changeset_emotion(attrs)
    |> update
  end

  @doc """
  Adds city into cities db table
  """
  def insert_city(city) do
    %City{}
    |> City.changeset(%{name: city})
    |> insert!
  end

  @doc """
  Returns city, that was found by name
  """

  @spec get_city(binary) :: %Review{}
  def get_city(city) do
    one(from c in City, where: c.name == ^city)
  end

  @doc """
  Returns all %Emotion{}
  """
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


  @spec start_transaction_with_callback(atom | %{group_by: any}, fun) :: any
  def start_transaction_with_callback(opts, callback) do
    opts.group_by
    |> get_view_type
    |> transaction_with_function(opts, callback)
  end

  defp transaction_with_function(view, opts, callback) do
    transaction(fn -> callback.(opts, stream(from r in view, select: r)) end)
  end

  defp transaction_with_function({:error, _descr} = error, _opts, _callback) do
    error
  end

  defp get_view_type(select_type) do
    case select_type do
      :gender -> Review_Gender
      :city -> Review_City
      :emotion -> Review_Emotion
      :month -> Review_Month
      :time -> Review_Time
      _ -> {:error, :undefined_view_type}
    end
  end

  @doc """
  Calls update_mat_views() procedure for refreshing all materialized views
  """
  def refresh_views() do
    Ecto.Adapters.SQL.query(SobesReview.Repo, "call update_mat_views()")
  end

  @doc """
  Prelads all city and emition for specific review and returns this review
  """
  @spec preload_review_deps(%Review{}) :: %Review{}
  def preload_review_deps(review) do
    review |> preload(:city) |> preload(:emotion)
  end
end
