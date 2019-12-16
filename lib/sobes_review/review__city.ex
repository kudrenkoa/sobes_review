defmodule SobesReview.Review_City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mv_review_city" do
    field :city, :string
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(review__city, attrs) do
    review__city
    |> cast(attrs, [:text, :city])
    |> validate_required([:text, :city])
  end
end
