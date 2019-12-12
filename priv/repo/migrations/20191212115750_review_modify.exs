defmodule SobesReview.Repo.Migrations.ReviewModify do
  use Ecto.Migration

  def change do
    alter table("reviews") do
      modify :name, :string, size: 50, null: false
      modify :text, :text, null: false
      modify :city, :string, size: 80, null: false
      modify :datetime, :utc_datetime, null: false
    end

  end
end
