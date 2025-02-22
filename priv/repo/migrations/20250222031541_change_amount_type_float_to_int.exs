defmodule Cora.Repo.Migrations.ChangeAmountTypeFloatToInt do
  use Ecto.Migration

  def change do
    alter table(:recipe_ingredients) do
      modify :amount, :integer
    end
  end
end
