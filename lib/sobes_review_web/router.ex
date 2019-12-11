defmodule SobesReviewWeb.Router do
  use SobesReviewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", SobesReviewWeb do
    pipe_through :browser
    get "/", ReviewController, :index
    post "/reports", ReportsController, :create
    get "/reports/:group_by/:type", ReportsController, :get
  end

  # Other scopes may use custom stacks.
  # scope "/api", SobesReviewWeb do
  #   pipe_through :api
  # end
end
