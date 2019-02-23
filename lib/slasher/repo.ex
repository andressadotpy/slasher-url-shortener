defmodule Slasher.Repo do
  use Ecto.Repo,
    otp_app: :slasher,
    adapter: Ecto.Adapters.Postgres
end
