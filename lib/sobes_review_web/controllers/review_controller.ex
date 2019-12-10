defmodule SobesReviewWeb.ReviewController do
  use SobesReviewWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", count: "123", token: get_csrf_token())
  end

  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
    IO.puts upload.path
    redirect(conn, to: "/")
  end
end
