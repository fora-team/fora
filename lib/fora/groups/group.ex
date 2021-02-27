defmodule Fora.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "groups" do
    field :description, :string
    field :icon, :string
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:icon, :name, :slug, :description])
    |> validate_required([:icon, :name, :slug])
    |> validate_length(:icon, is: 1)
    |> update_change(:name, &String.trim/1)
    |> unsafe_validate_unique(:slug, Fora.Repo)
    |> unique_constraint(:slug)
  end
end
