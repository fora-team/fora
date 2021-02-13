defmodule ForaWeb.Id.UserController do
  use ForaWeb, :controller

  alias Fora.Kontos
  alias ForaWeb.Id.RegistrationUsingInviteForm, as: Form
  alias ForaWeb.UserAuth

  def create(conn, %{"registration_using_invite_form" => params}) do
    invite = Kontos.get_invite_by_token!(params["invitation_token"])

    {:ok, form} = Form.apply(%Form{}, params)

    params = %{
      first_name: form.first_name,
      last_name: form.last_name,
      password: form.password
    }

    {:ok, user} = Kontos.register_user_with_invitation(invite, params)

    conn
    |> put_flash(:info, "User created successfully.")
    |> UserAuth.log_in_user(user)
  end
end
