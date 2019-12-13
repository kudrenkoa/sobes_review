defmodule SobesReview.Repo.Migrations.Review_City_FKCityId do
  use Ecto.Migration

  def change do
    alter table(:reviews) do
      remove :city
      add :city_id, references("cities")
    end
  end
end
