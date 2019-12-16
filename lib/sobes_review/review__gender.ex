defmodule SobesReview.Review_Gender do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mv_review_gender" do
    field :gender, :boolean, default: false
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(review__gender, attrs) do
    review__gender
    |> cast(attrs, [:text, :gender])
    |> validate_required([:text, :gender])
  end
end
