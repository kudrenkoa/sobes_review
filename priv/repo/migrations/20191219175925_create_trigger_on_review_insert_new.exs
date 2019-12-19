defmodule SobesReview.Repo.Migrations.CreateTriggerOnReviewInsertNew do
  use Ecto.Migration

  def change do
    execute "CREATE FUNCTION inc_review_count() RETURNS trigger AS $rev_inc$
    BEGIN
    refresh materialized view mv_review_city;
    refresh materialized view mv_review_emotion;
    refresh materialized view mv_review_gender;
    refresh materialized view mv_review_month;
    refresh materialized view mv_review_time;
    RETURN NEW;
    END;
    $rev_inc$ LANGUAGE plpgsql;"
    execute "CREATE TRIGGER review_count_update_trigger AFTER INSERT ON reviews
    FOR EACH ROW EXECUTE PROCEDURE inc_review_count();"
  end
end
