defmodule SobesReview.Review_Month do
  use Ecto.Schema

  schema "mv_review_month" do
    field :month, :string
    field :text, :string
  end

  def fetch(review, accessor) do
    case accessor do
      :month -> {:ok, "#{review.month}"}
    end
  end
end
