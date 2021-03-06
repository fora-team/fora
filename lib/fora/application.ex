defmodule Fora.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Fora.Repo,
      # Start the Telemetry supervisor
      ForaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Fora.PubSub},
      # Start the Endpoint (http/https)
      ForaWeb.Endpoint,
      {Oban, Application.get_env(:fora, Oban)},
      {Fora.Kontos.InviteAdmin,
       [
         admin_email_address: System.get_env("FORA_FIRST_USER_EMAIL_ADDRESS"),
         send_invite_admin: Application.get_env(:fora, Fora.Kontos)[:send_invite_admin]
       ]}
      # Start a worker by calling: Fora.Worker.start_link(arg)
      # {Fora.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ForaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
