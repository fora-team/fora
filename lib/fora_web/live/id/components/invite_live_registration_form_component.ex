defmodule ForaWeb.Id.InviteLiveRegistrationFormComponent do
  use ForaWeb, :live_component

  alias ForaWeb.Id.RegistrationUsingInviteForm, as: Form

  @impl true
  def update(%{invite: invite, invitation_token: invitation_token}, socket) do
    form = %Form{email: invite.email, invitation_token: invitation_token}

    {:ok,
     socket
     |> assign(:form, form)
     |> assign(:trigger_submit, false)
     |> assign(:invite, invite)
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
       changeset: Form.validate(socket.assigns.form, form_params)
     )}
  end

  @impl true
  def handle_event("save", %{"registration_using_invite_form" => form_params}, socket) do
    changeset = Form.validate(socket.assigns.form, form_params)

    case Form.apply(changeset) do
      {:ok, _form} ->
        {:noreply, assign(socket, trigger_submit: true)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
