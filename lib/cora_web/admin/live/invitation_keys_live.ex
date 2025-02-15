defmodule CoraWeb.Admin.InvitationKeysLive do
  use CoraWeb, :live_view

  def render(assigns) do
    ~H"""
    <.button phx-click="new" class="mb-2">New</.button>

    <div class="grid grid-cols-1 gap-2">
      <%= for key <- @keys do %>
      <div class="border rounded-xl p-2 bg-white">
      <%= if key.used_by != nil do %>
        <span>Used by: {key.used_by.username}</span>
      <% end %>
        <div class="flex justify-between">
          <span class={"#{if key.used_by != nil, do: "line-through", else: "font-bold"}"}><%= key.key %></span>
          <span class="text-gray-500"><%= key.inserted_at %></span>
        </div>
      </div>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    keys = Cora.Accounts.InvitationKey.all_invitation_keys()
    {:ok, assign(socket, page_title: "Something", keys: keys)}
  end

  def handle_event("new", _, socket) do
    uuid = UUID.uuid1()
    {:ok, _invitation_key} = Cora.Accounts.InvitationKey.create_invitation_key(%{key: uuid})
    keys = Cora.Accounts.InvitationKey.all_invitation_keys()
    {:noreply, assign(socket, keys: keys)}
  end
end
