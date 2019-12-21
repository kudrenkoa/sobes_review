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
    city_id = get_or_create_city(attrs)
    attrs
    |> Repo.insert_review
    |> update_review_city(city_id)
    |> get_emotion_async(attrs.text)
    |> increment_review_count
  end

  def create_review({:error, _err} = error) do
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
      id -> id
    end
  end

  defp add_city(%{city: city_name}) do
    city = city_name
    |> Repo.insert_city
    |> Cache.insert_city
    city.id
  end

  defp update_review_city({:ok, review}, city_id) do
    Repo.update_review_city(review, city_id)
  end

  defp update_review_city({:error, _error} = error, _city_id) do
    error
  end

  defp get_emotion_async({:ok, review}, text) do
    PdotsClient.get_emotion_async(text, &(
      &1
      |> Cache.get_emotion_id
      |> Repo.update_review_emotion(review)
      |> refresh_views_async
    ))
    {:ok, review}
  end

  defp get_emotion_async({:error, _err} = error, _text) do
    error
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
