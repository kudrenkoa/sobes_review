defmodule SobesReview.Repo.Migrations.CreateEmotions do
  use Ecto.Migration

  def change do
    create table(:emotions) do
      add :name, :string, size: 8
    end
    execute "INSERT INTO emotions (name) VALUES('Happy'), ('Angry'), ('Excited'), ('Sad'), ('Fear'), ('Bored')"
  end
end
