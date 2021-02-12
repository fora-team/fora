defmodule ForaWeb.Id.InviteLiveTest do
  use ForaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fora.KontosFixtures

  alias Fora.Kontos

  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:invite) do
    {:ok, invite} = Kontos.create_invite(@create_attrs)
    invite
  end

  defp create_invite(_) do
    invite = fixture(:invite)
    %{invite: invite}
  end

  defp create_email(_) do
    %{email: unique_user_email()}
  end

  defp create_invitation_token(%{email: email}) do
    %{invitation_token: invite_user_fixture(%{email: email})}
  end

  describe "InviteLive" do
    setup [:create_email, :create_invitation_token]

    test "form1", %{conn: conn} do
      assert IO.inspect(
               render_component(ForaWeb.Id.InviteLiveRegistrationFormComponent,
                 id: :form1,
                 invite: %{email: "boo@boo.com", role: :admin}
               )
             )
    end

    test "enters user information", %{conn: conn, invitation_token: invitation_token} do
      {:ok, index_live, _html} = live(conn, Routes.id_invite_path(conn, :show, invitation_token))

      assert index_live
             |> form("#invite-form", registration_using_invite_form: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#invite-form",
          registration_using_invite_form: %{first_name: "M", password: "123A111Aaaaa"}
        )
        |> render_submit()
        |> follow_redirect(conn, "/")
    end
  end
end
