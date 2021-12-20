defmodule NoticeboardWeb.NoticeController do
  use NoticeboardWeb, :controller

  alias Noticeboard.Boards
  alias Noticeboard.Boards.Notice

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    notices = Boards.list_user_notices(current_user)
    render(conn, "index.html", notices: notices)
  end

  def new(conn, _params, _current_user) do
    changeset = Boards.change_notice(%Notice{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"notice" => notice_params}, current_user) do
    case Boards.create_notice(current_user, notice_params) do
      {:ok, notice} ->
        conn
        |> put_flash(:info, "Notice created successfully.")
        |> redirect(to: Routes.notice_path(conn, :show, notice))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    notice = Boards.get_user_notice!(current_user, id)
    render(conn, "show.html", notice: notice)
  end

  def edit(conn, %{"id" => id}, current_user) do
    notice = Boards.get_user_notice!(current_user, id)
    changeset = Boards.change_notice(notice)
    render(conn, "edit.html", notice: notice, changeset: changeset)
  end

  def update(conn, %{"id" => id, "notice" => notice_params}, current_user) do
    notice = Boards.get_user_notice!(current_user, id)

    case Boards.update_notice(notice, notice_params) do
      {:ok, notice} ->
        conn
        |> put_flash(:info, "Notice updated successfully.")
        |> redirect(to: Routes.notice_path(conn, :show, notice))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", notice: notice, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    notice = Boards.get_user_notice!(current_user, id)
    {:ok, _notice} = Boards.delete_notice(notice)

    conn
    |> put_flash(:info, "Notice deleted successfully.")
    |> redirect(to: Routes.notice_path(conn, :index))
  end
end
