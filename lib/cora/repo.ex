defmodule Cora.Repo do
  use Ecto.Repo,
    otp_app: :cora,
    adapter: Ecto.Adapters.Postgres
end
