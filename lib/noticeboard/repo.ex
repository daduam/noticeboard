defmodule Noticeboard.Repo do
  use Ecto.Repo,
    otp_app: :noticeboard,
    adapter: Ecto.Adapters.Postgres
end
