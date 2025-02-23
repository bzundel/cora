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
      <.banner>Create a new recipe</.banner>
      <.a href={~p"/recipes"}>Back</.a>
    </div>

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

      <hr/>

      <div class="flex-col gap-y-2">
        <%= for {ingredient, i} <- Enum.with_index(@ingredients) do %>
          <div class="flex gap-x-2 items-center">
            <span class="font-bold text-gray-500 mt-2">{"#{i + 1}."}</span>

            <div class="w-1/2">
              <.input field={@form[:"ingredient_#{i}_ingredient"]}
                placeholder="Name"
                phx-blur="update_ingredient"
                phx-value-id={ingredient.id}
                phx-value-field="ingredient"/>
            </div>
            <div class="w-3/8">
            <.input field={@form[:"ingredient_#{i}_amount"]}
              type="number"
              placeholder="Amount"
              phx-blur="update_ingredient"
              phx-value-id={ingredient.id}
              phx-value-field="amount"/>
            </div>
            <div class="w-1/8">
            <.input field={@form[:"ingredient_#{i}_measurement_id"]}
              type="select"
              options={measurement_options()}
              placeholder="Unit"
              phx-blur="update_ingredient"
              phx-value-id={ingredient.id}
              phx-value-field="measurement_id"/>
            </div>

            <button class="mt-2" phx-click="delete_ingredient" phx-value-id={ingredient.id} phx-disable-with="Deleting...">
              <span class="hero-trash"/>
            </button>
          </div>
        <% end %>

        <div class="grid justify-items-center mt-2">
          <button phx-click="add_ingredient" phx-disable-with="Adding..." class="p-1 bg-gray-100 hover:bg-gray-200 transition duration-300 rounded-full">
            <span class="hero-plus-circle"></span>
          </button>
        </div>
      </div>

      <hr/>

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

  defp measurement_options() do
    Measurement.all_measurements()
    |> Enum.map(&{&1.unit, &1.id})
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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

  @impl true
  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset = Recipe.change_recipe(socket.assigns.recipe, recipe_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    ingredients = socket.assigns.ingredients
    |> Enum.map(fn x -> Map.delete(x, :id) end)
    recipe_params = Map.put(recipe_params, "recipe_ingredients", ingredients)
    save_recipe(socket, :new, recipe_params)
  end

  def handle_event("add_ingredient", _params, socket) do
    id_next = try do
      Enum.max(Enum.map(socket.assigns.ingredients, fn x -> x.id end)) + 1
    rescue
      EmptyError -> 0
    end

    default_measurement = measurement_options() |> List.first() |> elem(1)

    ingredients = socket.assigns.ingredients ++ [%{id: id_next, ingredient: "", amount: nil, measurement_id: default_measurement}]
    {:noreply, assign(socket, ingredients: ingredients)}
  end

  def handle_event("update_ingredient", %{"id" => id, "field" => field, "value" => value}, socket) do
    id = String.to_integer(id)
    ingredients = Enum.map(socket.assigns.ingredients, fn ingredient ->
      if ingredient.id == id do
        value = case field do
          "ingredient" ->
            value
          "amount" ->
            if value != "" do
              String.to_integer(value)
            end
          "measurement_id" ->
            if value != "" do
              String.to_integer(value)
            end
        end
        Map.put(ingredient, String.to_atom(field), value)
      else
        ingredient
      end
    end)

    {:noreply, assign(socket, ingredients: ingredients)}
  end

  def handle_event("delete_ingredient", %{"id" => id}, socket) do
    id = String.to_integer(id)
    ingredients = socket.assigns.ingredients
    pending_delete_ingredient = Enum.find(ingredients, fn x -> x.id == id end)
    updated_ingredients = List.delete(ingredients, pending_delete_ingredient)

    {:noreply, assign(socket, ingredients: updated_ingredients)}
  end

  defp save_recipe(socket, :new, recipe_params) do
    IO.inspect(socket.assigns.ingredients)
    IO.inspect(recipe_params)

    case Recipe.create_recipe(recipe_params) do
      {:ok, recipe} ->
        {:noreply,
         socket
         |> put_flash(:info, "Recipe created successfully")
         |> push_navigate(to: ~p"/recipes/#{recipe.id}")}
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset.errors, label: "Changeset Errors")
        {:noreply, socket |> put_flash(:error, "Creating recipe has failed") |> assign(form: to_form(changeset))}
    end
  end
end
