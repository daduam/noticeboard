defmodule Noticeboard.Repo.Migrations.CreateNotices do
  use Ecto.Migration

  def change do
    create table(:notices) do
      add :title, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:notices, [:user_id])
  end
end
