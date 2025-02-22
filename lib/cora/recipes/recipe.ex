defmodule Cora.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cora.Recipes.RecipeIngredient
  alias Cora.Repo
  alias Cora.Recipes.Recipe

  schema "recipes" do
    field :name, :string
    field :instructions, :string
    field :description, :string
    field :prep_time, :integer
    field :cooking_time, :integer
    field :servings, :integer
    has_many :recipe_ingredients, Cora.Recipes.RecipeIngredient

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description, :prep_time, :cooking_time, :servings, :instructions])
    |> validate_required([:name, :description, :prep_time, :cooking_time, :servings, :instructions])
    |> cast_assoc(:recipe_ingredients, with: &RecipeIngredient.changeset/2)
  end

  def all_recipes do
    Recipe
    |> Repo.all()
  end

  def create_recipe(attrs \\ %{}) do
    IO.inspect(attrs, label: "Attributes being saved")

    changeset = %Recipe{}
    |> Recipe.changeset(attrs)

    IO.inspect(changeset, label: "Changeset before save")

    case Repo.insert(changeset) do
      {:ok, recipe} ->
        IO.inspect(recipe, label: "Saved recipe")
        {:ok, recipe}
      {:error, failed_changeset} ->
        IO.inspect(failed_changeset, label: "Failed changeset")
        {:error, failed_changeset}
    end
  end

  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
  end

  def get_recipe(id) do
    Repo.get!(Recipe, id)
  end
end
