defmodule SobesReviewWeb.Utils.ReviewsService do
  @moduledoc """
  Main logic for ReportController. For example - creating new review
  """
  alias SobesReviewWeb.Utils.PdotsClient
  alias SobesReview.Repo
  alias SobesReviewWeb.Utils.Cache
  alias SobesReviewWeb.Utils.SerializerOptions

  @doc """
  Creates new review, updates it with city_id, collect emotion from paralleldots api and increments review counter
  """
  def create_review({:ok, attrs}) do
    get_or_create_city(attrs)
    |> create_review_with_city(attrs)
  end

  def create_review({:error, _err} = error) do
    error
  end

  defp create_review_with_city({:ok, city}, attrs) do
    Repo.insert_review(attrs)
    |> update_review_city(city.id)
    |> get_emotion_async(attrs.text)
    |> increment_review_count
  end

  defp create_review_with_city({:error, _err} = error, _attrs) do
    error
  end

  @spec init_serializer_options(String.t, String.t) :: SobesReviewWeb.Utils.SerializerOptions.t()
  def init_serializer_options(group_by, type) do
    %SerializerOptions{group_by: String.to_atom(group_by), type: String.to_atom(type)}
  end

  defp get_or_create_city(attrs) do
    attrs.city
    |> Cache.get_city_id_by_name
    |> case do
      nil -> add_city(attrs)
      id -> {:ok, %{name: attrs.city, id: id}}
    end
  end

  defp add_city(%{city: city_name}) do
    Repo.insert_city(%{name: city_name})
    |> insert_city_to_cache
  end

  defp insert_city_to_cache({:ok, city}) do
    Cache.insert_city(city)
  end

  defp insert_city_to_cache({:error, _err} = error) do
    error
  end

  defp update_review_city({:ok, review}, city_id) do
    Repo.update_review_city(review, city_id)
  end

  defp update_review_city({:error, _error} = error, _city_id) do
    error
  end

  defp get_emotion_async({:ok, review} = message, text) do
    PdotsClient.get_emotion_async(text,
      fn emotion -> update_review_with_emotion(review, emotion) end)
    message
  end

  defp get_emotion_async({:error, _err} = error, _text) do
    error
  end

  defp update_review_with_emotion(review, emotion) do
    emotion_id = Cache.get_emotion_id(emotion)
    Repo.update_review_emotion(review, emotion_id)
    |> refresh_views_async
  end



  defp increment_review_count({:ok, _review} = message) do
    Cache.increment_reviews_count()
    message
  end

  defp increment_review_count({:error, _err} = error) do
    error
  end

  defp refresh_views_async({:ok, review} = message) do
    SobesReview.Repo.refresh_views()
    review
    |> Cache.insert_report
    |> SobesReview.Repo.preload_review_deps
    message
  end

  defp refresh_views_async({:error, _err} = error) do
    error
  end
end
