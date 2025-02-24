defmodule CoraWeb.Recipes.RecipeForm do
alias Enum.EmptyError
  use CoraWeb, :live_view

  alias Cora.Recipes
  alias Cora.Recipes.Recipe
  alias Cora.Recipes.Measurement

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-between">
      <.banner>
        <%= if assigns.live_action == :new do %>
          Create a new recipe
        <% else %>
          Edit recipe
        <% end %>
      </.banner>
      <.a href={~p"/recipes"}>Back</.a>
    </div>

    <.simple_form
      for={@form}
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

      <hr/>

      <fieldset>
        <.inputs_for :let={f_ingredient} field={@form[:recipe_ingredients]}>
          <div class="flex gap-x-2 items-center">
            <div class="w-1/2">
              <.input field={f_ingredient[:ingredient]} type="text"/>
            </div>
            <div class="w-1/4">
              <.input field={f_ingredient[:amount]} type="number"/>
            </div>
            <div class="w-1/4">
              <.input field={f_ingredient[:measurement_id]} type="select" options={measurement_options()}/>
            </div>
            <div class="">
              <.button phx-click="delete_ingredient" phx-value-index={f_ingredient.index} phx-disable-with="Deleting...">Delete</.button>
            </div>
          </div>
        </.inputs_for>

        <div class="grid items-center justify-items-center mt-2">
          <.button phx-click="add_ingredient" phx-disable-with="Adding...">
            Add
          </.button>
        </div>
      </fieldset>

      <hr/>

      <.input field={@form[:instructions]} type="textarea" rows={10} label="Instructions" />

      <:actions>
          <.button phx-disable-with="Saving..." type="submit">Save</.button>
      </:actions>
    </.simple_form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp measurement_options() do
    Measurement.all_measurements()
    |> Enum.map(&{&1.unit, &1.id})
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    changeset = Recipe.change_recipe(%Recipe{})
    default_measurement = measurement_options() |> List.first() |> elem(1)
    ingredients = [%{id: 0, ingredient: "", amount: nil, measurement_id: default_measurement}]

    assign(socket,
      page_title: "New recipe",
      recipe: %Recipe{},
      form: to_form(changeset),
      ingredients: ingredients
    )
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    changeset = Recipe.change_recipe(recipe)

    assign(socket,
      page_title: "Edit recipe",
      recipe: recipe,
      form: to_form(changeset)
    )
  end

  @impl true
  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset = Recipe.change_recipe(socket.assigns.recipe, recipe_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    save_recipe(socket, socket.assigns.live_action, recipe_params)
  end

  def handle_event("add_ingredient", _params, socket) do
    default_measurement = measurement_options() |> List.first() |> elem(1)
    socket = update(socket, :form, fn %{source: changeset} ->
      existing = Ecto.Changeset.get_assoc(changeset, :recipe_ingredients)
      changeset = Ecto.Changeset.put_assoc(changeset, :recipe_ingredients, existing ++ [%{id: 0, ingredient: "", amount: nil, measurement_id: default_measurement}])
      to_form(changeset)
    end)

    {:noreply, socket}
  end

  def handle_event("delete_ingredient", %{"index" => index}, socket) do
    index = String.to_integer(index)
    socket = update(socket, :form, fn %{source: changeset} ->
      existing = Ecto.Changeset.get_field(changeset, :recipe_ingredients)
      IO.inspect(changeset, label: "Pre-delete changeset", limit: :infinity)
      changeset = Ecto.Changeset.put_assoc(changeset, :recipe_ingredients, List.delete_at(existing, index))
      IO.inspect(changeset, label: "Post-delete changeset", limit: :infinity)
      to_form(changeset)
    end)
    {:noreply, socket}
  end

  defp save_recipe(socket, :new, recipe_params) do
    case Recipe.create_recipe(recipe_params) do
      {:ok, recipe} ->
        {:noreply,
         socket
         |> put_flash(:info, "Recipe created successfully")
         |> push_navigate(to: ~p"/recipes/#{recipe.id}")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> put_flash(:error, "Creating recipe has failed") |> assign(form: to_form(changeset))}
    end
  end

  defp save_recipe(socket, :edit, recipe_params) do
    IO.inspect(recipe_params, label: "Recipe params")
    case Recipes.update_recipe(socket.assigns.recipe, recipe_params) do
      {:ok, recipe} ->
        {:noreply,
         socket
         |> put_flash(:info, "Successfully edited recipe")
         |> push_navigate(to: ~p"/recipes/#{recipe.id}")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> put_flash(:error, "Error while saving changes") |> assign(form: to_form(changeset))}
    end
  end
end
