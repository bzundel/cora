defmodule Cora.Repo.Migrations.CreateInvitationKeys do
  use Ecto.Migration

  def change do
    create table(:invitation_keys) do
      add :key, :uuid
      add :used_by, references(:users, on_delete: :nothing), null: true

      timestamps(type: :utc_datetime)
    end

    create index(:invitation_keys, [:used_by])
  end
end
