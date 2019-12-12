defmodule SobesReview.Repo.Migrations.ReviewsAlterColumn do
  use Ecto.Migration

  def change do
    alter table("reviews") do
      add :emotion, :string, size: 20, null: false
    end
  end
end
