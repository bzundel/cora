defmodule CoraWeb.Admin.InvitationKeysLive do
  alias Cora.Accounts.InvitationKey
  use CoraWeb, :live_view

  alias Cora.Repo

  @impl true
  def render(assigns) do
    ~H"""
    <.button phx-click="new" class="mb-2">New</.button>

    <div class="grid grid-cols-1 gap-2">
      <%= for key <- @keys do %>
        <div class="flex gap-x-2">
          <div class="border rounded-xl p-2 bg-white grow">
            <%= if key.used_by != nil do %>
              <div class="flex justify-between">
                <span class="font-bold">Used by: {key.used_by.username}</span>
                <span class="text-gray-500">{key.updated_at}</span>
              </div>
            <% end %>
            <div class="flex justify-between">
              <span class={"#{if key.used_by != nil, do: "line-through", else: "font-bold"}"}>
                {key.key}
              </span>
              <span class="text-gray-500">{key.inserted_at}</span>
            </div>
          </div>
          <%= if key.used_by == nil do %>
            <.button phx-click="delete" phx-value-id={key.id}>Delete</.button>
          <% end %>
        </div>
      <% end %>
    </div>

    <.modal :if={@show_confirm_dialog} id="confirm-modal" show on_cancel={JS.push("close_modal")}>
      <.live_component
        module={CoraWeb.Dialogs.ConfirmDialog}
        id="confirm_dialog"
        title="Confirm delete"
        subtitle="Are you sure you want to delete this item?"
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    keys = Cora.Accounts.InvitationKey.all_invitation_keys()

    socket =
      socket
      |> assign(:page_title, "Invitation keys")
      |> assign(:keys, keys)
      |> assign(:show_confirm_dialog, false)
      |> assign(:pending_delete_key_id, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("new", _, socket) do
    uuid = UUID.uuid1()
    {:ok, _invitation_key} = Cora.Accounts.InvitationKey.create_invitation_key(%{key: uuid})
    keys = Cora.Accounts.InvitationKey.all_invitation_keys()
    {:noreply, assign(socket, keys: keys)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:noreply, assign(socket, show_confirm_dialog: true, pending_delete_key_id: id)}
  end

  def handle_event("close_modal", _params, socket) do
    socket =
      socket
      |> assign(:show_confirm_dialog, false)
      |> assign(:pending_delete_key_id, nil)

    {:noreply, socket}
  end

  @impl true
  def handle_info({CoraWeb.Dialogs.ConfirmDialog, value}, socket) do
    socket =
      case value do
        true ->
          updated_keys = delete_key(socket.assigns.pending_delete_key_id)

          socket
          |> assign(:keys, updated_keys)
          |> put_flash(:info, "Successfully deleted key")

        false ->
          socket
      end

    socket =
      socket
      |> assign(:show_confirm_dialog, false)
      |> assign(:pending_delete_key_id, nil)

    {:noreply, socket}
  end

  defp delete_key(key_id) do
    InvitationKey.delete_key_by_id(key_id)
    InvitationKey.all_invitation_keys()
  end
end
