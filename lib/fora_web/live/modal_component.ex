defmodule ForaWeb.ModalComponent do
  use ForaWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""



        <%= live_component @socket, @component, @opts %>

    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
