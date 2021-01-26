defmodule Fora.Kontos.UserNotifier do
  import Bamboo.Email

  def deliver(to, subject, body) do
    %{to: to, subject: subject, body: body, from: "fora@fora.local"}
    |> Fora.Kontos.EmailDeliveryWorker.new()
    |> Oban.insert()

    {:ok, %{to: to, body: body}}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "sub", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "sub", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "sub", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  def deliver_invitation_instructions(send_to, invited_by, url) do
    deliver(send_to, "Invitation", """

    ==============================

    Hi #{send_to},

    You are invited to Fora by #{invited_by.first_name}.

    You can finish your registration by visiting the URL below:

    #{url}

    ==============================
    """)
  end
end
