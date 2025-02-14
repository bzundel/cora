defmodule CoraWeb.Admin.InvitationKeysLive do
  use CoraWeb, :live_view

  def render(assigns) do
    ~H"""
    <button phx-click="new">New</button>
    <ul>
      <%= for key <- @keys do %>
        <li><%= key.key %></li>
      <% end %>
    </ul>
    """
  end

  def mount(_params, _session, socket) do
    keys = Cora.Accounts.InvitationKey.all_invitation_keys()
    {:ok, assign(socket, keys: keys)}
  end

  def handle_event("new", _, socket) do
    uuid = UUID.uuid1()
    {:ok, _invitation_key} = Cora.Accounts.InvitationKey.create_invitation_key(%{key: uuid})
    keys = Cora.Accounts.InvitationKey.all_invitation_keys()
    {:noreply, assign(socket, keys: keys)}
  end
end
