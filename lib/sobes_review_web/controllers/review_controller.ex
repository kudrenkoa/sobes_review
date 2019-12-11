defmodule SobesReviewWeb.ReviewController do
  use SobesReviewWeb, :controller
  import SobesReview.Repo, only: [get_review_count: 0, add_review: 1]
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]

  def index(conn, _params) do
    render(conn, "index.html", count: get_review_count(), token: get_csrf_token())
  end

  @spec create(any, any) :: none
  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
    upload.path
    |> decode
    |> add_review
    redirect(conn, to: "/")
  end
end
