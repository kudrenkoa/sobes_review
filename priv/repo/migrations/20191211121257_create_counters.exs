defmodule SobesReview.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :name, :string
      add :value, :integer

      timestamps()
    end
    execute "INSERT INTO counters (name, value, inserted_at, updated_at) VALUES ('review', (SELECT COUNT(*) FROM reviews), NOW(), NOW());"
  end
end
