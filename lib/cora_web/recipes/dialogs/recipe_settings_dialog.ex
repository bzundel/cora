defmodule CoraWeb.Recipes.Dialogs.RecipeSettingsDialog do
  use CoraWeb, :live_component

  alias Cora.Recipes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="mb-4">
        {@title}
        <:subtitle>{@subtitle}</:subtitle>
      </.header>

      <span>Unfortunately there are no settings <strong>yet</strong>.</span>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :page_title, "Recipe settings")}
  end
end
