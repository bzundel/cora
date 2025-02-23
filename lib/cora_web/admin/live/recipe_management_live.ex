defmodule CoraWeb.Admin.RecipeManagementLive do
  use CoraWeb, :live_view

  alias Cora.Recipes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="mb-4">
        Recipe administration
        <:subtitle>Manage all settings related to recipes that are not in control of the user</:subtitle>
      </.header>

      <span class="font-bold text-l">Measurements</span>
      <div class="flex flex-col gap-y-1 my-2">
        <%= for measurement <- @measurements do %>
          <div class="flex justify-between items-center hover:bg-gray-100 rounded-xl transition duration-300 p-1 ps-4">
            <span>{measurement.unit}</span>
            <.button class="p-2" phx-click="delete_measurement" phx-value-id={measurement.id}>Delete</.button>
          </div>
        <% end %>
      </div>

      <form phx-submit="add_measurement">
        <div class="flex gap-x-2 items-center">
          <input class="w-full rounded-xl py-1" type="text" name="unit" placeholder="Unit" value={@new_measurement.unit} />
          <.button type="submit">Add</.button>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    measurements = Recipes.all_measurements()

    IO.inspect(measurements)

    {:ok, assign(socket, measurements: measurements, new_measurement: %{unit: ""})}
  end

  @impl true
  def handle_event("add_measurement", %{"unit" => unit}, socket) do
    socket = case Recipes.create_measurement(unit) do
      {:ok, _} ->
        measurements = Recipes.all_measurements()
        assign(socket, :measurements, measurements)
      {:error, _} ->
        put_flash(socket, :error, "Something went wrong while creating the new measurement")
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_measurement", %{"id" => id}, socket) do
    Recipes.delete_measurement(id)
    measurements = Recipes.all_measurements()

    {:noreply, socket
      |> assign(:measurements, measurements)
      |> put_flash(:info, "Successfully delete measurement!")}
  end
end
