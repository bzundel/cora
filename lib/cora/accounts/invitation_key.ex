defmodule Cora.Accounts.InvitationKey do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Cora.Repo
  alias Cora.Accounts.{InvitationKey, User}

  schema "invitation_keys" do
    field :key, :string
    belongs_to :used_by, User, foreign_key: :used_by_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invitation_key, attrs) do
    invitation_key
    |> cast(attrs, [:key])
    |> validate_required([:key])
  end

  def all_invitation_keys do
    from(ik in InvitationKey,
      order_by: [desc: ik.inserted_at])
    |> Repo.all()
    |> Repo.preload(:used_by)
  end

  def create_invitation_key(attrs \\ %{}) do
    %InvitationKey{}
    |> InvitationKey.changeset(attrs)
    |> Repo.insert()
  end

  @spec check_key(String.t()) :: {:error, String.t()} | {:ok, InvitationKey}
  def check_key(key_uuid) do
    case Repo.get_by(InvitationKey, key: key_uuid) do
      nil -> {:error, "The specified key does not exist."}
      key ->
        if key.used_by_id == nil do
          {:ok, key}
        else
          {:error, "The specified key has been used."}
        end
    end
  end

  def mark_key_used(key, user_id) do
    key
    |> Ecto.Changeset.change(used_by_id: user_id)
    |> Repo.update()
  end

  def delete_key_by_id(id) do
    key = Repo.get(InvitationKey, id)
    Repo.delete(key)
  end
end
