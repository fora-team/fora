defmodule Fora.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:groups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :icon, :string
      add :name, :string
      add :slug, :string
      add :description, :string

      timestamps()
    end

    create unique_index(:groups, :slug)
  end
end
