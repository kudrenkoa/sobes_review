defmodule SobesReview.Review_Gender do
  use Ecto.Schema

  schema "mv_review_gender" do
    field :gender, :boolean, default: false
    field :text, :string
  end

  def fetch(review, accessor) do
    case accessor do
      :gender -> case review.gender do
        true -> {:ok, "male"}
        false -> {:ok, "female"}
      end
    end
  end
end
