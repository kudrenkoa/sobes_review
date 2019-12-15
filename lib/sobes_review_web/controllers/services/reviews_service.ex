defmodule SobesReviewWeb.Utils.ReviewsService do
  alias SobesReviewWeb.Utils.PdotsClient
  alias SobesReview.Repo
  alias SobesReviewWeb.Utils.Cache

  def create_review({:ok, attrs}) do
    city_id = get_city_id(attrs)
    attrs
    |> Repo.insert_review
    |> Repo.update_review_city(city_id)
    |> PdotsClient.get_emotion(attrs.text, &update_emotions_callback/2)
    |> Cache.increment_reviews_count
  end

  defp get_city_id(attrs) do
    attrs.city
    |> Cache.get_city_id_by_name
    |> case do
      nil -> add_city(attrs)
      id -> id
    end
  end

  defp update_emotions_callback(review, emotion) do
    IO.puts "RECEIVED EMOTION #{emotion}"
    emotion
    |> Cache.get_emotion_id
    |> Repo.update_review_emotion(review)
  end

  defp add_city(%{city: city_name}) do
    city = city_name
    |> SobesReview.Repo.insert_city
    |> Cache.insert_city
    city.id
  end
end
