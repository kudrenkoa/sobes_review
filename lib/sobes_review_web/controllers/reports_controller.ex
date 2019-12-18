defmodule SobesReviewWeb.ReportsController do
  use SobesReviewWeb, :controller
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]
  import SobesReviewWeb.Utils.Validators, only: [validate_decoded_data: 1]
  import SobesReviewWeb.Utils.ReviewsService, only: [create_review: 1]
  import SobesReviewWeb.Utils.ReviewSerializerBridge, only: [create_report: 1]
  alias SobesReviewWeb.Utils.SerializerOptions

  def create(conn, %{"upload" => %Plug.Upload{} = upload}) do
    upload.path
    |> decode
    |> validate_decoded_data
    |> create_review
    |> render_response(conn)
  end

  def get(conn, %{"group_by" => group_by, "type" => type = "html"} = _params) do
    {res, report} = create_report(%SerializerOptions{group_by: String.to_atom(group_by), type: String.to_atom(type)})
    # {res, report} = create_report({String.to_atom(group_by), String.to_atom(type)})
    case res do
      :ok -> html(conn, report)
      :error -> html(conn, "error occured")
    end
  end

  def render_response({:ok, _data}, conn) do
    redirect(conn, to: "/")
  end

  def render_response({:error, error}, conn) do
    render(conn, "errors.html", error: error)
  end
end
