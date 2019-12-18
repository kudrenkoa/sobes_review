defmodule SobesReviewWeb.ReportsView do
  use SobesReviewWeb, :view

  def render_error_message(error) do
    case error do
      :invalid_file_format -> "Incorrect file format"
      :no_file -> "Internal server error: unable to find file"
      :empty_file -> "Empty file"
      :no_review_text -> "\"Text\" field is empty"
      :paralleldots_error -> "Internal server error: Unable to retrieve emotion"
      :server_error -> "Internal server error: Paralleldots api returned error. Try again later"
      error -> error
    end
  end
end
