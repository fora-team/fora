defmodule Fora.KontosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fora.Kontos` context.
  """
  alias Fora.Kontos.Invite

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "8iI0191kKplsk1-10"

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

  def invite_user_fixture(attrs \\ %{}) do
    invited_by = Map.get_lazy(attrs, :invited_by, &system_user_fixture/0)
    send_to = Map.get_lazy(attrs, :email, &unique_user_email/0)
    role = attrs[:role] || :normal
    {encoded_token, invite} = Invite.build_invite_token(send_to, invited_by, :admin)
    Fora.Repo.insert!(invite)

    encoded_token
  end
end
