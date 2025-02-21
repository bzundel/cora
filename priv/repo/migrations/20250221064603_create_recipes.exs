defmodule Cora.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string
      add :description, :string
      add :prep_time, :integer
      add :cooking_time, :integer
      add :servings, :integer
      add :instructions, :string

      timestamps(type: :utc_datetime)
    end
  end
end
