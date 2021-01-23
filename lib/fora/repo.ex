defmodule Fora.Repo do
  use Ecto.Repo,
    otp_app: :fora,
    adapter: Ecto.Adapters.Postgres
end
