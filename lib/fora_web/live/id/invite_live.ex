defmodule ForaWeb.Id.InviteLive do
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
  def render(assigns) do
    ForaWeb.IdView.render("invite_live.html", assigns)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"token" => token}) do
    invite = Kontos.get_invite_by_token!(token)

    socket
    |> assign(:token, token)
    |> assign(:invite, invite)
    |> assign(:form1, nil)
    |> assign(:form2, nil)
    |> assign(:form_step, :form1)
  end

  @impl
  def handle_info({ForaWeb.Id.InviteLiveRegistrationFormComponent, :form_completed, form}, socket) do
    IO.inspect(socket.assigns)

    {:noreply,
     socket
     |> assign(:form_step, :form2)
     |> assign(:form1, form)}
  end

  @impl
  def handle_info({ForaWeb.Id.InviteLive2FAFormComponent, :form_completed, form}, socket) do
    attrs = Map.merge(Map.from_struct(socket.assigns.form1), Map.from_struct(form))

    Kontos.register_invitee(attrs, socket.assigns.invite)

    {:noreply, assign(socket, form_step: :finished, form2: form)}
  end
end
