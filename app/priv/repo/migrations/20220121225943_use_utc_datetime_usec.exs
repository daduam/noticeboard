defmodule Noticeboard.Repo.Migrations.UseUtcDatetimeUsec do
  use Ecto.Migration

  def change do
    # users
    Enum.each(["confirmed_at", "inserted_at", "updated_at"], fn column ->
      execute("""
      ALTER TABLE users
      ALTER #{column} TYPE timestamptz USING #{column} AT TIME ZONE 'UTC'
      , ALTER #{column} SET DEFAULT now();
      """)
    end)

    # users_tokens
    execute("""
    ALTER TABLE users_tokens
    ALTER inserted_at TYPE timestamptz USING inserted_at AT TIME ZONE 'UTC'
    , ALTER inserted_at SET DEFAULT now();
    """)
  end
end
