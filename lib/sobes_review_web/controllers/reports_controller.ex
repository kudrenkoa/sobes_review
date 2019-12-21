defmodule SobesReviewWeb.ReportsController do
  use SobesReviewWeb, :controller

  alias SobesReviewWeb.Utils.Csv
  alias SobesReviewWeb.Utils.Validators
  alias SobesReviewWeb.Utils.ReviewsService
  alias SobesReviewWeb.Utils.ReviewSerializerBridge

  def create(conn, %{"upload" => %Plug.Upload{} = upload}) do
    upload.path
    |> Csv.decode
    |> Validators.validate_decoded_data
    |> ReviewsService.create_review
    |> render_response(conn)
  end

  def get(conn, %{"group_by" => group_by, "type" => type} = _params) do
    options = ReviewsService.init_serializer_options(group_by, type)
    ReviewSerializerBridge.create_report_from_cache(options)
    |> handle_report_result(conn, options)
  end


  defp handle_report_result({:ok, report}, conn, options) do
    conn
    |> prepare_response(options)
    |> chunk(report)
    |> case do
      {:ok, cn} -> cn
      {:error, err} = err -> render_response(err, conn)
    end
  end

  defp handle_report_result({:error, _err}, conn, _options) do
    render_response({:error, :server_error}, conn)
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
