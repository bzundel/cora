defmodule CoraWeb.Recipes.Index do
  use CoraWeb, :live_view

  alias Cora.Recipes

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-between mb-4">
      <.banner>Recipes</.banner>

      <.button phx-click="navigate_new_recipe">New</.button>
    </div>

    <div class="flex flex-col gap-y-2">
      <%= for recipe <- @recipes do%>
        <.link navigate={~p"/recipes/#{recipe.id}"}>
          <div class="p-2 rounded-xl bg-gray-100 grid grid-cols-2">
            <span class="col-span-3 font-bold">{recipe.name}</span>
            <span class="col-span-3 text-sm text-gray-700">{recipe.description}</span>
            <span class="text-sm">{"Prep. time: #{recipe.prep_time} mins"}</span>
            <span class="text-sm">{"Cooking time: #{recipe.cooking_time} mins"}</span>
          </div>
        </.link>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    recipes = Cora.Recipes.Recipe.all_recipes()

    socket =
      socket
      |> assign(:page_title, "Recipes")
      |> assign(:recipes, recipes)

    {:ok, socket}
  end

  @impl true
  def handle_event("navigate_new_recipe", _params, socket) do
    socket = case Enum.empty?(Recipes.Measurement.all_measurements()) do
      true ->
        put_flash(socket, :error, "You must add a measurement first!")
      false ->
        push_navigate(socket, to: ~p"/recipes/new")
    end

    {:noreply, socket}
  end
end
