defmodule ForaWeb.Id.InviteLiveTest do
  use ForaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fora.KontosFixtures

  defp create_email(_) do
    %{email: unique_user_email()}
  end

  defp create_invitation_token(%{email: email}) do
    %{invitation_token: invite_user_fixture(%{email: email})}
  end

  describe "InviteLive" do
    setup [:create_email, :create_invitation_token]

    test "enters user information", %{conn: conn, invitation_token: invitation_token} do
      {:ok, index_live, _html} = live(conn, Routes.id_invite_path(conn, :show, invitation_token))

      assert index_live
             |> form("#invite-form", registration_using_invite_form: %{})
             |> render_change() =~ "can&apos;t be blank"
    end
  end
end
