defmodule Fora.Kontos.InviteAdmin do
  @moduledoc """
  This GenServer checks if there is no user in the system, sends an email to
  the admin(read from `FORA_FIRST_USER_EMAIL_ADDRESS` env var) and invite the first admin.

  The invitation link can also be found the server logs.
  """
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(args) do
    if args[:send_invite_admin] do
      Process.send_after(self(), :invite_admin_if_needed, 5000)
      {:ok, args}
    else
      :ignore
    end
  end

  @impl true
  def handle_info(:invite_admin_if_needed, state) do
    case Fora.Kontos.list_users() do
      [system_user] ->
        unless state[:admin_email_address],
          do: raise("Missing FORA_FIRST_USER_EMAIL_ADDRESS environment variable")

        {:ok, %{body: body}} =
          Fora.Kontos.deliver_invite_admin(
            state[:admin_email_address],
            system_user,
            &ForaWeb.Router.Helpers.id_invite_url(ForaWeb.Endpoint, :show, &1)
          )

        Logger.info("the admin is invited: #{body}")

      [] ->
        raise "Missing system user, run the seeds please!"

      _ ->
        :noop
    end

    {:noreply, state}
  end
end
