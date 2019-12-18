defmodule SobesReview.Review_Emotion do
  use Ecto.Schema

  schema "mv_review_emotion" do
    field :emotion, :string
    field :text, :string
  end

  def fetch(review, accessor) do
    case accessor do
      :emotion -> {:ok, review.emotion}
    end
  end
end
