defmodule CoraWeb.UserRegistrationLive do
  use CoraWeb, :live_view

  alias Cora.Accounts
  alias Cora.Accounts.{User, InvitationKey}

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Cora is a strictly private service. If you were not invited, you may not create an account.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:username]} type="text" label="Username" required />
        <.input field={@form[:first_name]} type="text" label="First name" required />
        <.input field={@form[:last_name]} type="text" label="Last name" required />
        <.input field={@form[:email]} type="text" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />
        <.input name="invitation_key" errors={@invitation_key_error} value={@invitation_key_value} type="text" label="Invitation key" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(page_title: "Register")
      |> assign(trigger_submit: false)
      |> assign(check_errors: false)
      |> assign(invitation_key_value: nil)
      |> assign(invitation_key_error: [])
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params, "invitation_key" => key_uuid}, socket) do
    case InvitationKey.check_key(key_uuid) do
      {:error, error} ->
        IO.puts(error)
        {:noreply, socket |> assign(check_errors: true, invitation_key_error: [error])}
      {:ok, key} ->
        case Accounts.register_user(user_params) do
          {:ok, user} ->
            InvitationKey.mark_key_used(key, user.id)

            {:ok, _} =
              Accounts.deliver_user_confirmation_instructions(
                user,
                &url(~p"/users/confirm/#{&1}")
              )

            changeset = Accounts.change_user_registration(user)
            {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
        end
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
