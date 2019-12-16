defmodule SobesReview.Repo.Migrations.CreateMaterializedViews do
  use Ecto.Migration

  def change do
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_gender AS select id, text, gender FROM reviews ORDER BY gender WITH data;"
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_city AS select reviews.id, text, cities.name AS city FROM reviews INNER JOIN cities ON reviews.city_id = cities.id ORDER BY cities.name WITH data;"
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_emotion AS select reviews.id, text, emotions.name AS emotion FROM reviews INNER JOIN emotions ON reviews.emotion_id = emotions.id ORDER BY emotions.name WITH data;"
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_month AS select id, name, EXTRACT(MONTH FROM datetime) AS month FROM reviews ORDER BY 3 WITH data;"
    execute "CREATE MATERIALIZED VIEW IF NOT EXISTS mv_review_time AS select id, name, TO_CHAR(datetime, 'HH:MI') AS time FROM reviews ORDER BY 3 WITH data;"
  end
end
