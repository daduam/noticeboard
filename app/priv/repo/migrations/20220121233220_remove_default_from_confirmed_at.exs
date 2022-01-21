defmodule Noticeboard.Repo.Migrations.RemoveDefaultFromConfirmedAt do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE users ALTER COLUMN confirmed_at DROP DEFAULT", ""
  end
end
