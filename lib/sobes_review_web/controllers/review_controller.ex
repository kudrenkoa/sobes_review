defmodule SobesReviewWeb.ReviewController do
  use SobesReviewWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", count: "0")
  end
end
