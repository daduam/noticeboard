defmodule Noticeboard.BoardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Noticeboard.Boards` context.
  """

  @doc """
  Generate a notice.
  """
  def notice_fixture(attrs \\ %{}) do
    {:ok, notice} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Noticeboard.Boards.create_notice()

    notice
  end
end
