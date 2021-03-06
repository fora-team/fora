defmodule ForaWeb.Id.InviteControllerTest do
  use ForaWeb.ConnCase
  import Fora.KontosFixtures

  defp create_invitation_token(_) do
    %{invitation_token: invite_user_fixture()}
  end

  describe "create account" do
    setup [:create_invitation_token]

    test "registers a user with valid params", %{conn: conn, invitation_token: invitation_token} do
      create_params = %{
        "first_name" => "name",
        "last_name" => "",
        "password" => "ssAaaaa111111111111",
        "invitation_token" => invitation_token
      }

      conn =
        post(conn, Routes.id_user_path(conn, :create),
          registration_using_invite_form: create_params
        )

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"
    end
  end
end
