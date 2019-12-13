defmodule SobesReview.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :datetime, :utc_datetime, null: false
    field :gender, :boolean, default: false
    field :name, :string, size: 50, null: false
    field :text, :string, null: false
    belongs_to :emotion, SobesReview.Emotion
    belongs_to :city, SobesReview.City
    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:name, :gender, :text, :datetime])
    |> validate_required([:name, :gender, :text, :datetime])
  end
end
