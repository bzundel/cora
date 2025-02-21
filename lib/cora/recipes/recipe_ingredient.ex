defmodule Cora.Recipes.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_ingredients" do
    field :ingredient, :string
    field :amount, :float
    field :recipe_id, :id
    field :measurement_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    recipe_ingredient
    |> cast(attrs, [:ingredient, :amount])
    |> validate_required([:ingredient, :amount])
  end
end
