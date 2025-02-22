defmodule Cora.Recipes.Measurement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cora.Repo
  alias Cora.Recipes.Measurement

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

  def all_measurements() do
    Repo.all(Measurement)
  end
end
