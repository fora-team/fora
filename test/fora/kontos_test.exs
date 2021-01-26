defmodule Fora.KontosTest do
  use Fora.DataCase
  use Oban.Testing, repo: Fora.Repo

  alias Fora.Kontos
  import Fora.KontosFixtures

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
end
