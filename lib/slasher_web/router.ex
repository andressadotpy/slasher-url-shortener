defmodule SlasherWeb.Router do
  use SlasherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SlasherWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SlasherWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/slasher", SlasherWeb do
    pipe_through :browser

    get "/new", LinkController, :new
    get "/:id", LinkController, :show
    post "/", LinkController, :create
  end
end
