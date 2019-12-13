defmodule SobesReviewWeb.ReviewController do
  use SobesReviewWeb, :controller
  import SobesReviewWeb.Utils.Cache, only: [get_reviews_count: 0]

  def index(conn, _params) do
    render(conn, "index.html", count: get_reviews_count(), token: get_csrf_token())
  end
end
