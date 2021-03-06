defmodule ForaWeb.PageLive do
  use ForaWeb, :live_view

  alias Fora.Groups.Group

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Group")
    |> assign(:group, %Group{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Group")
    |> assign(:group, nil)
  end
end
