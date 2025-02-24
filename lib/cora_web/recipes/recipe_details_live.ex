defmodule CoraWeb.Recipes.DetailsLive do
  use CoraWeb, :live_view

  alias Cora.Recipes

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-between mb-2">
      <.banner>{@recipe.name}</.banner>
      <div class="flex-shrink-0">
        <.a href={~p"/recipes/edit/#{@recipe.id}"}>Edit</.a>
        <.a href={~p"/recipes"}>Back</.a>
      </div>
    </div>

    <hr class="my-2"/>

    <div class="flex flex-col gap-y-8">
      <div>
        <span class="text-l font-bold">Description</span>
        <p>{@recipe.description}</p>
      </div>

      <div class="flex gap-x-4">
          <span class="text-sm"><strong>Prep. time:</strong> {@recipe.prep_time} mins</span>
          <span class="text-sm"><strong>Cooking time:</strong> {@recipe.cooking_time} mins</span>
      </div>

      <div>
        <span class="text-l font-bold">Ingredients</span>

        <%= if Enum.empty?(@recipe.recipe_ingredients) do %>
          <div class="flex items-center justify-center mt-4">
            <span class="text-sm text-zinc-500">No ingredients found</span>
          </div>
        <% else %>
          <div class="flex gap-x-2 items-center mb-4">
            <span class="text-sm">Servings: </span>
            <input type="number" name="desired_servings" class="py-1 rounded-lg text-zinc-900 focus:ring-0 sm:text-sm" value={@desired_servings} phx-blur="desired_servings_changed" min="1" placeholder="Servings"/>
          </div>
          <div class="grid grid-cols-2">
            <%= for ingredient <- @recipe.recipe_ingredients do %> <!-- FIXME fix this goofy field naming (recipe.recipe_ingredients and ingredient.ingredient) -->
              <span>{ingredient.ingredient}</span>
              <span>{(ingredient.amount / @recipe.servings) * @desired_servings} {ingredient.measurement.unit}</span>
            <% end %>
          </div>
        <% end %>
      </div>

      <div>
        <span class="text-l font-bold">Instructions</span>
        <p>
          <%= Phoenix.HTML.raw(String.replace(@recipe.instructions, "\n", "<br>")) %>
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    recipe = Cora.Recipes.get_recipe!(id)

    socket =
      socket
      |> assign(:page_title, "Recipe: #{recipe.name}")
      |> assign(:recipe, recipe)
      |> assign(:desired_servings, recipe.servings)

    {:ok, socket}
  end

  @impl true
  def handle_event("desired_servings_changed",  %{"value" => desired_servings}, socket) do
    #recipe = socket.assigns.recipe
    #recipe_servings = recipe.servings
    desired_servings = String.to_integer(desired_servings) # TODO do some proper unit conversions, pretty rounding, etc.

    {:noreply, assign(socket, :desired_servings, desired_servings)}
  end
end
