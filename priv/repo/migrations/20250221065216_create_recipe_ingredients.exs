defmodule Cora.Repo.Migrations.CreateRecipeIngredients do
  use Ecto.Migration

  def change do
    create table(:recipe_ingredients) do
      add :ingredient, :string
      add :amount, :float
      add :recipe_id, references(:recipes, on_delete: :nothing)
      add :measurement_id, references(:measurements, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_ingredients, [:recipe_id])
    create index(:recipe_ingredients, [:measurement_id])
  end
end
