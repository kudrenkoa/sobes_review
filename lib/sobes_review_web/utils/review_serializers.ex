defmodule SobesReviewWeb.Utils.ReviewSerializer do

  def serialize_review(_type = :html, review) do
    "<tr><td>#{review.id}</td><td>#{review.text}</td></tr>"
  end

  def get_table(_type = :html, header, inner_parts) do
    "<h1>#{header}</h1><table>#{inner_parts}</table>"
  end
end
