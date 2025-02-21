defmodule Cora.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cora.Repo
  alias Cora.Recipes.Recipe

  schema "recipes" do
    field :name, :string
    field :instructions, :string
    field :description, :string
    field :prep_time, :integer
    field :cooking_time, :integer
    field :servings, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description, :prep_time, :cooking_time, :servings, :instructions])
    |> validate_required([:name, :description, :prep_time, :cooking_time, :servings, :instructions])
  end

  def all_recipes do
    Recipe
    |> Repo.all()
  end

  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
  end

  def get_recipe(id) do
    Repo.get!(Recipe, id)
  end
end
