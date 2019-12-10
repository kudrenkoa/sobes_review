defmodule SobesReview.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :name, :string
      add :gender, :boolean, default: false, null: false
      add :city, :string
      add :text, :string
      add :datetime, :utc_datetime

      timestamps()
    end

  end
end
