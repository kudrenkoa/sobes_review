defmodule SobesReviewWeb.ReportsController do
  use SobesReviewWeb, :controller
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]
  import SobesReviewWeb.Utils.Validators, only: [validate_decoded_data: 1]
  import SobesReviewWeb.Utils.ReviewsService, only: [create_review: 1, init_serializer_options: 2]
  import SobesReviewWeb.Utils.ReviewSerializerBridge, only: [create_report: 1]

  def create(conn, %{"upload" => %Plug.Upload{} = upload}) do
    upload.path
    |> decode
    |> validate_decoded_data
    |> create_review
    |> render_response(conn)
  end

  def get(conn, %{"group_by" => group_by, "type" => type} = _params) do
    options = init_serializer_options(group_by, type)
    {res, report} = create_report(options)
    case res do
      :ok -> send_chunked_report(conn, report, options)
      :error -> render_response({:error, :server_error}, conn)
    end
  end

  defp send_chunked_report(conn, report, options) do
    conn
    |> prepare_response(options)
    |> chunk(report)
    |> case do
      {:ok, cn} -> cn
      {:error, err} = err -> render_response(err, conn)
    end
  end

  defp prepare_response(conn, %{group_by: group_by, type: :html}) do
    conn
    |> put_resp_content_type("text/html")
    |> put_resp_header("content-disposition", ~s[attachment; filename="report_#{group_by}.html"])
    |> send_chunked(:ok)
  end

  defp prepare_response(conn, %{group_by: group_by, type: :xlsx}) do
    conn
    |> put_resp_content_type("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    |> put_resp_header("content-disposition", ~s[attachment; filename="report_#{group_by}.xlsx"])
    |> send_chunked(:ok)
  end

  defp render_response({:ok, _data}, conn) do
    redirect(conn, to: "/")
  end

  defp render_response({:error, error}, conn) do
    render(conn, "errors.html", error: error)
  end



end
