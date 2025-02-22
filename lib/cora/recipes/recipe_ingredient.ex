defmodule Cora.Recipes.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_ingredients" do
    field :ingredient, :string
    field :amount, :integer
    belongs_to :recipe, Cora.Recipes.Recipe
    belongs_to :measurement, Cora.Recipes.Measurement

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    recipe_ingredient
    |> cast(attrs, [:ingredient, :amount, :measurement_id])
    |> validate_required([:ingredient, :amount, :measurement_id])
  end
end
