defmodule Fora.KontosTest do
  use Fora.DataCase
  use Oban.Testing, repo: Fora.Repo

  alias Fora.Kontos
  import Fora.KontosFixtures

  defp create_invitation_token(_) do
    %{invitation_token: invite_user_fixture()}
  end

  def valid_register_param(_) do
    %{
      valid_register_param: %{
        first_name: "name",
        last_name: nil,
        password: valid_user_password()
      }
    }
  end

  describe "deliver_invite_admin/3" do
    setup do
      %{admin_email_addr: "admin@locahost.local"}
    end

    test "invites an admin", %{admin_email_addr: admin_email_addr} do
      system = system_user_fixture()

      token =
        extract_user_token(fn url ->
          Kontos.deliver_invite_admin(admin_email_addr, system, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert invite_token = Repo.get_by(Kontos.Invite, token: :crypto.hash(:sha256, token))
      assert invite_token.email == admin_email_addr
    end

    test "enqueues a job to send an email" do
      system = system_user_fixture()

      Kontos.deliver_invite_admin("admin@locahost.local", system, fn token ->
        "/id/invites?token=#{token}"
      end)

      assert [%{args: %{"to" => "admin@locahost.local"}}] =
               all_enqueued(worker: Fora.Kontos.EmailDeliveryWorker)
    end
  end

  describe "register_user_with_invitation/2" do
    setup [:create_invitation_token, :valid_register_param]

    test "registers a user with valid invitation_token", %{
      invitation_token: invitation_token,
      valid_register_param: params
    } do
      invite = Kontos.get_invite_by_token!(invitation_token)

      assert {:ok, user} = Kontos.register_user_with_invitation(invite, params)
      assert user.email == invite.email
      assert user.role == invite.role
      refute user.hashed_password == params[:password]
    end

    test "marks the invite as redeemed for the new user", %{
      invitation_token: invitation_token,
      valid_register_param: params
    } do
      invite = Kontos.get_invite_by_token!(invitation_token)
      refute invite.redeemed_at
      assert {:ok, user} = Kontos.register_user_with_invitation(invite, params)
      invite = Fora.Repo.reload!(invite)
      assert invite.redeemed_at
      assert invite.redeemed_by_id == user.id
    end

    test "can not reuse a redeemed invitation token", %{
      invitation_token: invitation_token,
      valid_register_param: params
    } do
      invite =
        invitation_token
        |> Kontos.get_invite_by_token!()
        |> Ecto.Changeset.change(%{
          redeemed_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
        })
        |> Fora.Repo.update!()

      assert_raise FunctionClauseError,
                   "no function clause matching in Fora.Kontos.register_user_with_invitation/2",
                   fn ->
                     Kontos.register_user_with_invitation(invite, params)
                   end
    end
  end
end
