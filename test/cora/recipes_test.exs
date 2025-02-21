defmodule Cora.RecipesTest do
  use Cora.DataCase

  alias Cora.Recipes

  describe "recipes" do
    alias Cora.Recipes.Recipe

    import Cora.RecipesFixtures

    @invalid_attrs %{name: nil, instructions: nil, description: nil, prep_time: nil, cooking_time: nil, servings: nil}

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Recipes.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Recipes.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      valid_attrs = %{name: "some name", instructions: "some instructions", description: "some description", prep_time: 42, cooking_time: 42, servings: 42}

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(valid_attrs)
      assert recipe.name == "some name"
      assert recipe.instructions == "some instructions"
      assert recipe.description == "some description"
      assert recipe.prep_time == 42
      assert recipe.cooking_time == 42
      assert recipe.servings == 42
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      update_attrs = %{name: "some updated name", instructions: "some updated instructions", description: "some updated description", prep_time: 43, cooking_time: 43, servings: 43}

      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, update_attrs)
      assert recipe.name == "some updated name"
      assert recipe.instructions == "some updated instructions"
      assert recipe.description == "some updated description"
      assert recipe.prep_time == 43
      assert recipe.cooking_time == 43
      assert recipe.servings == 43
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
      assert recipe == Recipes.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
    end
  end
end
