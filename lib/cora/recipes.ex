defmodule Cora.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias Cora.Repo

  alias Cora.Recipes.Recipe
  alias Cora.Recipes.Measurement

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id) do
   Repo.get!(Recipe, id)
   |> Repo.preload(recipe_ingredients: :measurement)
  end

  @doc """
  Gets a single recipe by id.

  Returns `{:ok, recipe}` if an entity with the given `id` was found, else `:error`.
  """
  def get_recipe(id) do
    case Repo.get(Recipe, id) do
      nil ->
        :error
      recipe ->
        {:ok, recipe}
    end
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
  end

  @doc """
  Returns all `Measurement` entities.
  """
  def all_measurements do
    Repo.all(Measurement)
  end

  @doc """
  Creates a new `Measurement` entity from a string `unit`.
  """
  def create_measurement(unit) do
    %Measurement{}
    |> Measurement.changeset(%{unit: unit})
    |> Repo.insert()
  end

  @doc """
  Delete a `Measurement` entity from a provided `id`.
  """
  def delete_measurement(id) do
    Repo.get!(Measurement, id)
    |> Repo.delete()
  end
end
