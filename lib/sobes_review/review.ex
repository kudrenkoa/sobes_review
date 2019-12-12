defmodule SobesReview.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :city, :string, size: 80, null: false
    field :datetime, :utc_datetime, null: false
    field :gender, :boolean, default: false
    field :name, :string, size: 50, null: false
    field :text, :string, null: false
    field :emotion, :string, null: false

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:name, :gender, :city, :text, :datetime, :emotion])
    |> validate_required([:name, :gender, :city, :text, :datetime, :emotion])
  end
end
