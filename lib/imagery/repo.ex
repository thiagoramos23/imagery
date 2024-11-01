defmodule Imagery.Repo do
  use Ecto.Repo,
    otp_app: :imagery,
    adapter: Ecto.Adapters.Postgres
end
