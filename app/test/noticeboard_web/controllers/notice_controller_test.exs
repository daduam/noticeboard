defmodule NoticeboardWeb.NoticeControllerTest do
  use NoticeboardWeb.ConnCase

  import Noticeboard.BoardsFixtures

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  describe "index" do
    test "lists all notices", %{conn: conn} do
      conn = get(conn, Routes.notice_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Notices"
    end
  end

  describe "new notice" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.notice_path(conn, :new))
      assert html_response(conn, 200) =~ "New Notice"
    end
  end

  describe "create notice" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.notice_path(conn, :create), notice: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.notice_path(conn, :show, id)

      conn = get(conn, Routes.notice_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Notice"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.notice_path(conn, :create), notice: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Notice"
    end
  end

  describe "edit notice" do
    setup [:create_notice]

    test "renders form for editing chosen notice", %{conn: conn, notice: notice} do
      conn = get(conn, Routes.notice_path(conn, :edit, notice))
      assert html_response(conn, 200) =~ "Edit Notice"
    end
  end

  describe "update notice" do
    setup [:create_notice]

    test "redirects when data is valid", %{conn: conn, notice: notice} do
      conn = put(conn, Routes.notice_path(conn, :update, notice), notice: @update_attrs)
      assert redirected_to(conn) == Routes.notice_path(conn, :show, notice)

      conn = get(conn, Routes.notice_path(conn, :show, notice))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, notice: notice} do
      conn = put(conn, Routes.notice_path(conn, :update, notice), notice: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Notice"
    end
  end

  describe "delete notice" do
    setup [:create_notice]

    test "deletes chosen notice", %{conn: conn, notice: notice} do
      conn = delete(conn, Routes.notice_path(conn, :delete, notice))
      assert redirected_to(conn) == Routes.notice_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.notice_path(conn, :show, notice))
      end
    end
  end

  defp create_notice(_) do
    notice = notice_fixture()
    %{notice: notice}
  end
end
