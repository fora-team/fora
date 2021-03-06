defmodule ForaWeb.Id.InviteLiveProgressBarComponent do
  use ForaWeb, :live_component

  def render(assigns) do
    ForaWeb.IdView.render("components/invite_live_progress_bar.html", assigns)
  end
end
