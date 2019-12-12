defmodule SobesReviewWeb.ReportsView do
  use SobesReviewWeb, :view

  def render_error_message(error) do
    case error do
      :invalid_file_format -> "Your file has an incorrect format"
      :no_file -> "Internal server error: unable to find file"
      :empty_file -> "Your file is empty"
      :no_review_text -> "\"Text\" field is empty"
      :paralleldots_error -> "Internal server error: Paralleldots api returned error. Try again later"
    end
  end
end
