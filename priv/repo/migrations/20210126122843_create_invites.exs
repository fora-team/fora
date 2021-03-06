defmodule Fora.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :binary, null: false
      add :email, :string, null: false
      add :role, :string, null: false
      add :redeemed_at, :naive_datetime
      add :redeemed_by_id, references(:users, on_delete: :nothing, type: :binary_id), null: true
      add :invited_by_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:invites, [:invited_by_id])
  end
end
