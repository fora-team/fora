defmodule Fora.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fora.Groups` context.
  """

  alias Fora.Groups
  def unique_slug(name), do: "#{name}-#{System.unique_integer()}"

  def group_fixture(attrs \\ %{}) do
    name = Map.get(attrs, :name, "group name")

    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: name,
        slug: unique_slug(name),
        icon: "😇",
        description: ""
      })
      |> Groups.create_group()

    group
  end
end
