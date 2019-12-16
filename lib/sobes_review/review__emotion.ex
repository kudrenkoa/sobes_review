defmodule SobesReview.Review_Emotion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mv_review_emotion" do
    field :emotion, :string
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(review__emotion, attrs) do
    review__emotion
    |> cast(attrs, [:text, :emotion])
    |> validate_required([:text, :emotion])
  end
end
