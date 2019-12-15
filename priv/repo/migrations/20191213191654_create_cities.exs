defmodule SobesReview.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string, size: 80, null: false, unique: true
      timestamps()
    end

    create unique_index(:cities, [:name])
  end
end
