defmodule SobesReview.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :city, :string
    field :datetime, :utc_datetime
    field :gender, :boolean, default: false
    field :name, :string
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:name, :gender, :city, :text, :datetime])
    |> validate_required([:name, :gender, :city, :text, :datetime])
  end
end
