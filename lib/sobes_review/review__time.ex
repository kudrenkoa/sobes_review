defmodule SobesReview.Review_Time do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mv_review_time" do
    field :text, :string
    field :time, :string

    timestamps()
  end

  @doc false
  def changeset(review__time, attrs) do
    review__time
    |> cast(attrs, [:text, :time])
    |> validate_required([:text, :time])
  end
end
