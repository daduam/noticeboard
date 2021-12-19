defmodule NoticeboardWeb.SessionController do
  use NoticeboardWeb, :controller

  alias Noticeboard.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(
        conn,
        %{"session" => %{"username" => username, "password" => pwd}}
      ) do
    case Accounts.authenticate_by_username_and_pwd(username, pwd) do
      {:ok, user} ->
        conn
        |> NoticeboardWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> NoticeboardWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
