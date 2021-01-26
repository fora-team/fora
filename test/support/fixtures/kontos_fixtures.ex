defmodule Fora.KontosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fora.Kontos` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def system_user_fixture() do
    Fora.Repo.insert!(
      Ecto.Changeset.change(%Fora.Kontos.User{}, %{
        email: "system@local",
        first_name: "sistemo",
        hashed_password: "NOLOGIN",
        role: :system
      })
    )
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password()
      })
      |> Fora.Kontos.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
