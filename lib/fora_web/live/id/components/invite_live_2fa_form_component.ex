defmodule ForaWeb.Id.InviteLive2FAFormComponent do
  use ForaWeb, :live_component

  alias Fora.Kontos
  alias ForaWeb.Id.Registration2FAForm, as: Form

  @impl true
  def update(assigns = %{invite: invite}, socket) do
    # secret_2fa = Base.encode32(:crypto.strong_rand_bytes(30), padding: false)
    secret_2fa = "T4NEVIGPGBUAVBQAK7SL2JWQPMPZBHOMOES34IKVEISDWY37"
    form = %Form{secret_2fa: secret_2fa}

    IO.inspect(:pot.totp(secret_2fa))

    qrcode =
      "otpauth://totp/Fora:#{invite.email}?secret=#{secret_2fa}"
      |> EQRCode.encode()
      |> EQRCode.svg(width: 200)

    {:ok,
     socket
     |> assign(:form, form)
     |> assign(:secret_2fa_qr_code, qrcode)
     |> assign(:changeset, Form.changeset(form, %{}))}
  end

  @impl true
  def render(assigns) do
    ForaWeb.IdView.render("components/invite_live_2fa_form.html", assigns)
  end

  @impl true
  def handle_event("validate", %{"registration2_fa_form" => form_params}, socket) do
    {:noreply,
     assign(
       socket,
       :changeset,
       Form.validate(socket.assigns.form, form_params)
     )}
  end

  @impl
  def handle_event("save", %{"registration2_fa_form" => _form2_params}, socket) do
    case Form.apply(socket.assigns.changeset) do
      {:ok, form} ->
        send(self(), {__MODULE__, :form_completed, form})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
