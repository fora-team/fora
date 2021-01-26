defmodule Fora.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :binary, null: false
      add :email, :string
      add :redeemed_at, :naive_datetime
      add :invited_by_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :user_final_id, references(:users, on_delete: :nothing, type: :binary_id), null: true

      timestamps()
    end

    create index(:invites, [:invited_by_id])
  end
end
