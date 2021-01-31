defmodule ForaWeb.Id.InviteLiveRegistrationFormComponent do
  use ForaWeb, :live_component

  alias Fora.Kontos
  alias ForaWeb.Id.RegistrationUsingInviteForm, as: Form

  @impl true
  def update(assigns = %{invite: invite}, socket) do
    form = %Form{email: invite.email, role: invite.role}

    {:ok,
     socket
     |> assign(:form, form)
     |> assign(:changeset, Form.changeset(form, %{}))}

    # |> assign(:changeset, assigns.changeset)}
  end

  @impl true
  def render(assigns) do
    ForaWeb.IdView.render("components/invite_live_registration_form.html", assigns)
  end

  @impl true
  def handle_event("validate", %{"registration_using_invite_form" => form_params}, socket) do
    {:noreply,
     assign(
       socket,
       :changeset,
       Form.validate(socket.assigns.form, form_params)
     )}
  end

  @impl
  def handle_event("save", %{"registration_using_invite_form" => _form1_params}, socket) do
    case Form.apply(socket.assigns.changeset) do
      {:ok, form} ->
        send(self(), {__MODULE__, :form_completed, form})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
