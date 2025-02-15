defmodule Cora.Repo.Migrations.RenameUsedByToUsedById do
  use Ecto.Migration

  def change do
    rename table(:invitation_keys), :used_by, to: :used_by_id
  end
end
