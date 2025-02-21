defmodule Cora.Recipes.Measurement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "measurements" do
    field :unit, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(measurement, attrs) do
    measurement
    |> cast(attrs, [:unit])
    |> validate_required([:unit])
  end
end
