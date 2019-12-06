defmodule SobesReviewWeb.PageController do
  use SobesReviewWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
