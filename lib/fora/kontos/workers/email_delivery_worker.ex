defmodule Fora.Kontos.EmailDeliveryWorker do
  use Oban.Worker, queue: :mail_delivery
  import Bamboo.Email

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{"to" => to, "subject" => subject, "body" => body, "from" => from_email}
      }) do
    new_email()
    |> to(to)
    |> from(from_email)
    |> subject(subject)
    |> html_body(body)
    |> text_body(body)
    |> Fora.Mailer.deliver_now()

    :ok
  end
end
