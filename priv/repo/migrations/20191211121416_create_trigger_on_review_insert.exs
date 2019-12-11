defmodule SobesReview.Repo.Migrations.CreateTriggerOnReviewInsert do
  use Ecto.Migration

  def change do
    execute "CREATE FUNCTION inc_review_count() RETURNS trigger AS $rev_inc$
      BEGIN
      UPDATE counters SET value = value + 1 WHERE name = 'review';
      RETURN NEW;
      END;
      $rev_inc$ LANGUAGE plpgsql;"
    execute "CREATE TRIGGER review_count_update_trigger AFTER INSERT ON reviews
             FOR EACH ROW EXECUTE PROCEDURE inc_review_count();"
  end
end
