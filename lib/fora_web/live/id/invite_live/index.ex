defmodule ForaWeb.Id.InviteLive.Index do
  use ForaWeb, :live_view

  alias Fora.Kontos
  alias Fora.Kontos.Invite
  alias ForaWeb.Id.RegistrationUsingInviteForm, as: Form1
  alias ForaWeb.Id.Registration2FAForm, as: Form2

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"token" => token}) do
    invite = Kontos.get_invite_by_token!(token)
    secret_2fa = Base.encode32(:crypto.strong_rand_bytes(30), padding: false)

    form1 = %Form1{email: invite.email, role: invite.role}
    form2 = %Form2{secret_2fa: secret_2fa}

    qrcode =
      "otpauth://totp/Fora:#{invite.email}?secret=#{secret_2fa}"
      |> EQRCode.encode()
      |> EQRCode.svg(width: 200)

    socket
    |> assign(:page_title, "Invite")
    |> assign(:changeset1, Form1.changeset(form1, %{}))
    |> assign(:changeset2, Form2.changeset(form2, %{}))
    |> assign(:invite, invite)
    |> assign(:secret_2fa, secret_2fa)
    |> assign(:secret_2fa_qr_code, qrcode)
    |> assign(:form_step, :form1)
    |> assign(:form1, form1)
    |> assign(:form2, form2)
  end

  @impl true
  def handle_event("validate", %{"registration_using_invite_form" => form1_params}, socket) do
    {:noreply,
     assign(
       socket,
       :changeset1,
       Form1.validate(socket.assigns.form1, form1_params)
     )}
  end

  @impl true
  def handle_event("validate", %{"registration2_fa_form" => form2_params}, socket) do
    {:noreply,
     assign(
       socket,
       :changeset2,
       Form2.validate(socket.assigns.form2, form2_params)
     )}
  end

  @impl
  def handle_event("save", %{"registration_using_invite_form" => _form1_params}, socket) do
    case Form1.apply(socket.assigns.changeset1) do
      {:ok, _} ->
        {:noreply, assign(socket, :form_step, :form2)}

      {:error, changeset1} ->
        {:noreply, assign(socket, :changeset1, changeset1)}
    end
  end

  @impl
  def handle_event("save", %{"registration2_fa_form" => _form2_params}, socket) do
    {:ok, form1} = Form1.apply(socket.assigns.changeset1)

    case Form2.apply(socket.assigns.changeset2) do
      {:ok, form2} ->
        attrs = Map.merge(Map.from_struct(form1), Map.from_struct(form2))

        Kontos.register_invitee(attrs, socket.assigns.invite)
        |> IO.inspect()

      {:error, changeset2} ->
        {:noreply, assign(socket, :changeset2, changeset2)}
    end
  end
end
