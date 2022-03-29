defmodule AccountsApiWeb.Router do
  use AccountsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AccountsApiWeb do
    pipe_through :api

    post "/event", AccountController, :handle_event
    post "/reset", AccountController, :reset

    get "/balance", AccountController, :get_balance
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
