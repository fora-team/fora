defmodule Fora.Groups do
  alias Fora.Repo
  alias Fora.Groups.Group

  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end

  def create_group(attrs) do
    %Group{}
    |> change_group(attrs)
    |> Repo.insert()
  end
end
