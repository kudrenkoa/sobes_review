defmodule SobesReview.Review_Month do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mv_review_month" do
    field :month, :integer
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(review__month, attrs) do
    review__month
    |> cast(attrs, [:text, :month])
    |> validate_required([:text, :month])
  end
end
