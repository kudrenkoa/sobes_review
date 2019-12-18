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

  def get(conn, %{"group_by" => group_by, "type" => type} = _params) do
    opts = init_serializer_options(group_by, type)
    {res, report} = create_report(opts)
    case res do
      :ok -> case type do
        "html" -> html(conn, report)
        "xlsx" -> send_chunked_report(conn, report)
      end
      :error -> render_response({:error, :server_error}, conn)
    end
  end

  defp send_chunked_report(conn, report) do
    conn
    |> put_resp_content_type("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    |> put_resp_header("content-disposition", ~s[attachment; filename="report.xlsx"])
    |> send_chunked(:ok)
    |> chunk(report)
    |> case do
      {:ok, cn} -> cn
      {:error, err} = err -> render_response(err, conn)
    end
  end

  defp render_response({:ok, _data}, conn) do
    redirect(conn, to: "/")
  end

  defp render_response({:error, error}, conn) do
    render(conn, "errors.html", error: error)
  end

  defp init_serializer_options(group_by, type) do
    %SerializerOptions{group_by: String.to_atom(group_by), type: String.to_atom(type)}
  end
end
