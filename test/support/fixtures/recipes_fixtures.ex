defmodule Cora.RecipesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cora.Recipes` context.
  """

  @doc """
  Generate a recipe.
  """
  def recipe_fixture(attrs \\ %{}) do
    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        cooking_time: 42,
        description: "some description",
        instructions: "some instructions",
        name: "some name",
        prep_time: 42,
        servings: 42
      })
      |> Cora.Recipes.create_recipe()

    recipe
  end
end
