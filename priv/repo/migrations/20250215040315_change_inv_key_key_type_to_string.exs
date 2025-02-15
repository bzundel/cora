defmodule Cora.Repo.Migrations.ChangeInvKeyKeyTypeToString do
  use Ecto.Migration

  def change do
    alter table(:invitation_keys) do
      modify :key, :string, from: :uuid
    end
  end
end
