defmodule NoticeboardWeb.Router do
  use NoticeboardWeb, :router

  import NoticeboardWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NoticeboardWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NoticeboardWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", NoticeboardWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
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

      live_dashboard "/dashboard", metrics: NoticeboardWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", NoticeboardWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/u/register", UserRegistrationController, :new
    post "/u/register", UserRegistrationController, :create
    get "/u/login", UserSessionController, :new
    post "/u/login", UserSessionController, :create
    get "/u/reset-password", UserResetPasswordController, :new
    post "/u/reset-password", UserResetPasswordController, :create
    get "/u/reset-password/:token", UserResetPasswordController, :edit
    put "/u/reset-password/:token", UserResetPasswordController, :update
  end

  scope "/", NoticeboardWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/u/settings", UserSettingsController, :edit
    put "/u/settings", UserSettingsController, :update
    get "/u/settings/confirm-email/:token", UserSettingsController, :confirm_email
  end

  scope "/", NoticeboardWeb do
    pipe_through [:browser]

    delete "/u/logout", UserSessionController, :delete
    get "/u/confirm", UserConfirmationController, :new
    post "/u/confirm", UserConfirmationController, :create
    get "/u/confirm/:token", UserConfirmationController, :edit
    post "/u/confirm/:token", UserConfirmationController, :update
  end
end
