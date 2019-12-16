defmodule SobesReviewWeb.Utils.ReviewsService do
  alias SobesReviewWeb.Utils.PdotsClient
  alias SobesReview.Repo
  alias SobesReviewWeb.Utils.Cache

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

  def update_review_city({:ok, review}, city_id) do
    Repo.update_review_city(review, city_id)
  end

  def update_review_city({:error, _error} = error, _city_id) do
    error
  end

  def get_emotion_async({:ok, review}, text) do
    PdotsClient.get_emotion_async(text, &(
      &1
      |> Cache.get_emotion_id
      |> Repo.update_review_emotion(review)
    ))
    {:ok, review}
  end

  def get_emotion_async({:error, _err} = error, _text) do
    error
  end

  def increment_review_count({:ok, _review} = message) do
    Cache.increment_reviews_count()
    message
  end

  def increment_review_count({:error, _err} = error) do
    error
  end
end