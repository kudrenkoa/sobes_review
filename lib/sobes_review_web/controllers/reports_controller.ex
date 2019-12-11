defmodule SobesReviewWeb.ReportsController do
  use SobesReviewWeb, :controller
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]
  import SobesReview.Repo, only: [add_review: 1]

  @spec create(any, any) :: none
  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
    upload.path
    |> decode
    |> add_review
    redirect(conn, to: "/")
  end
end
