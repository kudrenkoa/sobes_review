defmodule SobesReview.Counter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "counters" do
    field :name, :string
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(counter, attrs) do
    counter
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end
end
