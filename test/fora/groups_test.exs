defmodule Fora.GroupsTest do
  use Fora.DataCase

  alias Fora.Groups
  import Fora.GroupsFixtures

  @valid_attrs %{
    name: "valid name",
    slug: "valid-slug",
    icon: "🙋‍♀️",
    description: "valid description"
  }

  @invalid_attrs %{}
  describe "group" do
    alias Fora.Groups.Group

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Groups.create_group(@valid_attrs)
      assert group.name == "valid name"
    end

    test "create_group/1 with leading/ending space in name creates a group" do
      assert {:ok, %Group{} = group} = Groups.create_group(%{@valid_attrs | name: " hello "})
      assert group.name == "hello"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, changeset} = Groups.create_group(@invalid_attrs)

      assert errors_on(changeset) == %{
               slug: ["can't be blank"],
               icon: ["can't be blank"],
               name: ["can't be blank"]
             }
    end

    test "create_group/1 with invalid icon returns error changeset" do
      assert {:error, changeset} = Groups.create_group(%{@valid_attrs | icon: "💇🏽‍♂️  "})
      assert errors_on(changeset) == %{icon: ["should be 1 character(s)"]}
    end

    test "create_group/1 with duplicated slug returns error changeset" do
      group = group_fixture()
      assert {:error, changeset} = Groups.create_group(%{@valid_attrs | slug: group.slug})
      assert errors_on(changeset) == %{slug: ["has already been taken"]}
    end
  end
end
