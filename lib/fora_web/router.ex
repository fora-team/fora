defmodule ForaWeb.Router do
  use ForaWeb, :router

  import ForaWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ForaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ForaWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/group/new", PageLive, :new
  end

  scope "/id", ForaWeb.Id, as: :id do
    pipe_through :browser

    live "/invites/:token", InviteLive, :show
    post "/users/register", UserController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", ForaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard&Bamboo Viewer only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ForaWeb.Telemetry
    end

    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
