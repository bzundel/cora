defmodule CoraWeb.Dialogs.ConfirmDialog do
  use CoraWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>{@subtitle}</:subtitle>
      </.header>

      <div class="flex justify-end gap-x-2">
        <.button phx-click="confirm" phx-target={@myself} phx-value-answer="true">Confirm</.button>
        <.button phx-click="confirm" phx-target={@myself} phx-value-answer="false">Cancel</.button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("confirm", %{"answer" => answer}, socket) do
    notify_parent(String.to_existing_atom(answer))
    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

end
