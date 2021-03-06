# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fora.Repo.insert!(%Fora.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Fora.Repo.insert!(
  Ecto.Changeset.change(%Fora.Kontos.User{}, %{
    email: "system@local",
    first_name: "sistemo",
    hashed_password: "NOLOGIN",
    role: :system
  })
)
