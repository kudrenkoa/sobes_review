defmodule Review.Emotion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emotions" do
    field :name, :string
    has_many :reviews, Review.Model
  end

  @doc false
  def changeset(emotion, attrs) do
    emotion
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
