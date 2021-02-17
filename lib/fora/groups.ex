defmodule Fora.Groups do
  alias Fora.Repo
  alias Fora.Groups.Group

  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end
end
