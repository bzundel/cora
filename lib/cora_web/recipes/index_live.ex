defmodule CoraWeb.Recipes.Index do
  use CoraWeb, :live_view

  alias Cora.Repo
  alias Cora.Recipes.Recipe

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-between">
      <.banner>Recipes</.banner>
      <!--<div class="flex gap-x-2">
        <.a href={~p"/recipes/new"}>New</.a>
      </div>-->

      <.button phx-click="navigate_new_recipe">New</.button>
    </div>

    <ul>
    <%= for recipe <- @recipes do%>
      <li>{recipe.name}</li>
    <% end %>
    </ul>
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
    socket = case Enum.empty?(Cora.Recipes.Measurement.all_measurements()) do
      true ->
        put_flash(socket, :error, "You must add a measurement first!")
      false ->
        push_navigate(socket, to: ~p"/recipes/new")
    end

    {:noreply, socket}
  end
end
