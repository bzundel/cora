defmodule Cora.Accounts.InvitationKey do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cora.Repo
  alias Cora.Accounts.InvitationKey

  schema "invitation_keys" do
    field :key, Ecto.UUID
    field :used_by, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invitation_key, attrs) do
    invitation_key
    |> cast(attrs, [:key])
    |> validate_required([:key])
  end

  def all_invitation_keys do
    Repo.all(InvitationKey)
  end

  def create_invitation_key(attrs \\ %{}) do
    %InvitationKey{}
    |> InvitationKey.changeset(attrs)
    |> Repo.insert()
  end
end
