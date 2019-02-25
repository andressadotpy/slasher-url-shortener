defmodule SlasherWeb.Router do
  use SlasherWeb, :router

  alias SlasherWeb.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SlasherWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/sign-up", UserController, only: [:new, :create]
    post "/login", SessionController, only: [:create, :new]
    delete "/logout", SessionController, :delete
    resources "/users", UserController
    resources "/sessions", SessionController
  end

  scope "/links", SlasherWeb do
    pipe_through [:browser, :authenticate_user]

    get "/:id", LinkController, :get_long_url
    post "/slasher", LinkController, :make_short_url
    delete "/slash_delete", LinkController, :delete_short_url
    resources "/", LinkController
  end
end
