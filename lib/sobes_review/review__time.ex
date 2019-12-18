defmodule SobesReview.Review_Time do
  use Ecto.Schema

  schema "mv_review_time" do
    field :text, :string
    field :time, :string
  end

  def fetch(review, accessor) do
    case accessor do
      :time -> {:ok, review.time}
    end
  end
end
