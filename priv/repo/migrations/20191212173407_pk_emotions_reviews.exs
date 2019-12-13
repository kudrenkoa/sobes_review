defmodule SobesReview.Repo.Migrations.PkEmotionsReviews do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE reviews DROP COLUMN emotion;"
    alter table "reviews" do
      add :emotion_id, references("emotions")
    end
  end
end
