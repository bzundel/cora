defmodule CoraWeb.Recipes.Index do
  use CoraWeb, :live_view

  alias Cora.Repo
  alias Cora.Recipes.Recipe

  @impl true
  def render(assigns) do
    ~H"""
    <.banner text="Recipes"/>
    <.link href={~p"/recipes/new"}>New</.link>

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
end
