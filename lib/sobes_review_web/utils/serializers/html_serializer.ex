defmodule SobesReviewWeb.Utils.Serializers.Html do
  def one(review) do
    "<tr><td>#{review.id}</td><td>#{review.text}</td></tr>"
  end

  def header(header, inner_parts) do
    "<h1>#{header}</h1><table>#{inner_parts}</table>"
  end

  def start_value do
    ""
  end
  def append_result(value, result) do
    value <> result
  end
end
