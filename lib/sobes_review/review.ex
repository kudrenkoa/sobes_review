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

  # def fetch(review, accessor) do
  #   case accessor do
  #     "gender" -> {:ok, review.gender}
  #     "city" -> {:ok, review.city.name}
  #     "emotion" -> {:ok, review.emition.name}
  #     "month" -> {:ok, review.datetime.month}
  #     "time" -> {:ok, "#{review.datetime.hour}:#{review.datetime.minute}"}
  #   end
  # end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:name, :gender, :text, :datetime])
    |> validate_required([:name, :gender, :text, :datetime])
  end

  def changeset_city(review, attrs) do
    review
    |> cast(attrs, [:city_id])
    |> validate_required([:city_id])
  end

  def changeset_emotion(review, attrs) do
    review
    |> cast(attrs, [:emotion_id])
    |> validate_required([:emotion_id])
  end
end
