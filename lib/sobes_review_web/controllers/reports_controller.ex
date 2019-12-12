defmodule SobesReviewWeb.ReportsController do
  use SobesReviewWeb, :controller
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]
  import SobesReviewWeb.Utils.PdotsClient, only: [add_emotion: 1]
  import SobesReview.Repo, only: [add_review: 1]

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
    upload.path
    |> decode
    |> add_emotion
    |> add_review
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
