defmodule SobesReview.Repo.Migrations.InsertNewEmotion do
  use Ecto.Migration

  def change do
    execute "INSERT INTO emotions (name) VALUES ('undef');"
  end
end
