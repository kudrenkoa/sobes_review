defmodule SobesReviewWeb.ReviewController do
  use SobesReviewWeb, :controller
  import SobesReview.Repo, only: [get_review_count: 0]
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]

  def index(conn, _params) do
    render(conn, "index.html", count: get_review_count(), token: get_csrf_token())
  end
end
