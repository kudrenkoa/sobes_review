defmodule SobesReview.Repo.Migrations.CreateMaterializedViews do
  use Ecto.Migration

  def change do
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_gender AS select id, text, gender FROM reviews ORDER BY gender WITH data;"
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_city AS select reviews.id, text, cities.name AS city FROM reviews INNER JOIN cities ON reviews.city_id = cities.id ORDER BY cities.name WITH data;"
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_emotion AS select reviews.id, text, emotions.name AS emotion FROM reviews INNER JOIN emotions ON reviews.emotion_id = emotions.id ORDER BY emotions.name WITH data;"
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_month AS select id, text, EXTRACT(MONTH FROM datetime)::varchar(256) AS month FROM reviews ORDER BY 3 WITH data;"
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_time AS select id, text, TO_CHAR(datetime, 'HH:MI') AS time FROM reviews ORDER BY 3 WITH data;"
    execute "CREATE PROCEDURE update_mat_views()
    LANGUAGE SQL
    AS $$
    refresh materialized view mv_review_city;
    refresh materialized view  mv_review_emotion;
    refresh materialized view mv_review_gender;
    refresh materialized view mv_review_month;
    refresh materialized view mv_review_time;
    $$;"
  end

end
