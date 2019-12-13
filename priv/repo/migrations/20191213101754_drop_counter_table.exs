defmodule SobesReview.Repo.Migrations.DropCounterTable do
  use Ecto.Migration

  def change do
    execute "DROP TRIGGER IF EXISTS review_count_update_trigger ON reviews;"
    execute "DROP FUNCTION IF EXISTS inc_review_count;"
    execute "DROP TABLE IF EXISTS counters ;"
  end
end
