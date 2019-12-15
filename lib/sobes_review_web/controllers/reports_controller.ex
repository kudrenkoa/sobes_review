defmodule SobesReviewWeb.ReportsController do
  use SobesReviewWeb, :controller
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]
  import SobesReviewWeb.Utils.Validators, only: [validate_decoded_data: 1]
  import SobesReviewWeb.Utils.ReviewsService, only: [create_review: 1]

  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
    upload.path
    |> decode
    |> validate_decoded_data
    |> create_review
    |> render_response(conn)
  end

  def get(conn, %{"group_by" => _group_by, "type" => _type} = _params) do
    redirect(conn, to: "/")
  end

  def render_response({:ok, _data}, conn) do
    redirect(conn, to: "/")
  end

  def render_response({:error, error}, conn) do
    render(conn, "errors.html", error: error)
  end
end
