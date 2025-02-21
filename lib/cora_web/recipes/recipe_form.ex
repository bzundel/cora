defmodule CoraWeb.Recipes.RecipeForm do
  use CoraWeb, :live_view

  alias Cora.Recipes.Recipe

  @impl true
  def render(assigns) do
    ~H"""
    <.simple_form
      for={@form}
      id="recipe-form"
      phx-change="validate"
      phx-submit="save"
    >
      <.input field={@form[:name]} type="text" label="Name" />
      <.input field={@form[:description]} type="textarea" rows={4} label="Description" />
      <div class="flex gap-x-2">
        <div class="w-1/3">
          <.input field={@form[:prep_time]} type="number" label="Preparation time" />
        </div>
        <div class="w-1/3">
          <.input field={@form[:cooking_time]} type="number" label="Cooking time" />
        </div>
        <div class="w-1/3">
          <.input field={@form[:servings]} type="number" label="Servings" />
        </div>
      </div>
      <.input field={@form[:instructions]} type="textarea" rows={10} label="Instructions" />
      <:actions>
        <.button phx-disable-with="Saving...">Save</.button>
      </:actions>
    </.simple_form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    recipe = Recipe.get_recipe!(id)
    changeset = Recipe.change_recipe(recipe)

    assign(socket,
      page_title: "Edit recipe",
      recipe: recipe,
      form: to_form(changeset)
    )
  end

  defp apply_action(socket, :new, _params) do
    changeset = Recipe.change_recipe(%Recipe{})

    assign(socket,
      page_title: "New recipe",
      recipe: %Recipe{},
      form: to_form(changeset)
    )
  end

  @impl true
  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset = Recipe.change_recipe(socket.assigns.recipe, recipe_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    save_recipe(socket, :new, recipe_params)
  end

  defp save_recipe(socket, :new, recipe_params) do
    case Recipe.create_recipe(recipe_params) do
      {:ok, recipe} ->
        {:noreply,
         socket
         |> put_flash(:info, "Recipe created successfully")
         |> push_navigate(to: ~p"/recipes/#{recipe.id}")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
