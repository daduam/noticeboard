defmodule Noticeboard.Boards.Notice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notices" do
    field :description, :string
    field :title, :string

    belongs_to :user, Noticeboard.Accounts.User

    timestamps()
  end

  def changeset(notice, attrs) do
    notice
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
