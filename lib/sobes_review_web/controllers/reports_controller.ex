defmodule SobesReviewWeb.ReportsController do
  use SobesReviewWeb, :controller
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]
  import SobesReview.Repo, only: [add_review: 1]

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
    upload.path
    |> decode
    |> add_review
    redirect(conn, to: "/")
  end

  def get(conn, %{"group_by" => _group_by, "type" => _type} = _params) do
    redirect(conn, to: "/")
  end
end