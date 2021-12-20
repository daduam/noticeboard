defmodule Noticeboard.BoardsTest do
  use Noticeboard.DataCase

  alias Noticeboard.Boards

  describe "notices" do
    alias Noticeboard.Boards.Notice

    import Noticeboard.BoardsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_notices/0 returns all notices" do
      notice = notice_fixture()
      assert Boards.list_notices() == [notice]
    end

    test "get_notice!/1 returns the notice with given id" do
      notice = notice_fixture()
      assert Boards.get_notice!(notice.id) == notice
    end

    test "create_notice/1 with valid data creates a notice" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Notice{} = notice} = Boards.create_notice(valid_attrs)
      assert notice.description == "some description"
      assert notice.title == "some title"
    end

    test "create_notice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boards.create_notice(@invalid_attrs)
    end

    test "update_notice/2 with valid data updates the notice" do
      notice = notice_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Notice{} = notice} = Boards.update_notice(notice, update_attrs)
      assert notice.description == "some updated description"
      assert notice.title == "some updated title"
    end

    test "update_notice/2 with invalid data returns error changeset" do
      notice = notice_fixture()
      assert {:error, %Ecto.Changeset{}} = Boards.update_notice(notice, @invalid_attrs)
      assert notice == Boards.get_notice!(notice.id)
    end

    test "delete_notice/1 deletes the notice" do
      notice = notice_fixture()
      assert {:ok, %Notice{}} = Boards.delete_notice(notice)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_notice!(notice.id) end
    end

    test "change_notice/1 returns a notice changeset" do
      notice = notice_fixture()
      assert %Ecto.Changeset{} = Boards.change_notice(notice)
    end
  end
end
