defmodule Noticeboard.Boards do
  import Ecto.Query, warn: false
  alias Noticeboard.Repo
  alias Noticeboard.Boards.Notice
  alias Noticeboard.Accounts

  def list_notices do
    Repo.all(Notice)
  end

  def get_notice!(id), do: Repo.get!(Notice, id)

  def create_notice(%Accounts.User{} = user, attrs \\ %{}) do
    %Notice{}
    |> Notice.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_notice(%Notice{} = notice, attrs) do
    notice
    |> Notice.changeset(attrs)
    |> Repo.update()
  end

  def delete_notice(%Notice{} = notice) do
    Repo.delete(notice)
  end

  def change_notice(%Notice{} = notice, attrs \\ %{}) do
    Notice.changeset(notice, attrs)
  end

  def list_user_notices(%Accounts.User{} = user) do
    Notice
    |> user_notices_query(user)
    |> Repo.all()
  end

  def get_user_notice!(%Accounts.User{} = user, id) do
    Notice
    |> user_notices_query(user)
    |> Repo.get!(id)
  end

  defp user_notices_query(query, %Accounts.User{id: user_id}) do
    from n in query, where: n.user_id == ^user_id
  end
end
