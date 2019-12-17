defmodule SobesReview.Review_City do
  use Ecto.Schema

  schema "mv_review_city" do
    field :city, :string
    field :text, :string
  end

  def fetch(review, accessor) do
    case accessor do
      :city -> {:ok, review.city}
    end
  end
end
