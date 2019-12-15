defmodule SobesReview.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :name, :string
    has_many :reviews, SobesReview.Review

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
