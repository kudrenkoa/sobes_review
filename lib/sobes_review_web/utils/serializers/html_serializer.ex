defmodule SobesReviewWeb.Utils.Serializers.Html do
  @moduledoc """
  Logic of Html review serializer
  """

  @doc """
  Serializes review or map into <tr><td>id</td><td>text</td></tr>

  ## Examples
  iex> Html.one(%Review{id: 123, text: "super good!"})
  "<tr><td>123</td><td>super good!</td></tr>"
  """
  @spec one(%{id: any, text: any}) :: binary
  def one(review) do
    "<tr><td>#{review.id}</td><td>#{review.text}</td></tr>"
  end

  @doc """
  Serializes key and value into <h1>key</h1><table>inner_parts</table>

  ## Examples
  iex> Html.header("Tokyo", "<tr><td>123</td><td>super good!</td></tr>")\n
  "<h1>Tokyo</h1><table><tr><td>123</td><td>super good!</td></tr></table>"
  """
  @spec header(binary, binary) :: binary
  def header(title, inner_parts) do
    "<h1>#{title}</h1><table>#{inner_parts}</table>"
  end

  @doc """
  Creates start value of resulting data, that is specific for current serializer.
  For html serializer it is empty string.
  Used in functions such as Enum.reduce as start value for generating result of all serialization

  ## Example
  iex> Html.start_value()\n
  ""
  """
  @spec start_value :: <<>>
  def start_value do
    ""
  end

  @doc """
  Joins two serialized values into one.
  For html serializer it's two strings, that represents html code
  ## Examples
  iex> join_serialized_values("<p>hello</p>", "<p>world</p>")
  "<p>hello</p><p>world</p>"
  """
  @spec join_serialized_values(binary, binary) :: binary
  def join_serialized_values(value, result) do
    value <> result
  end

  def update_value(new_value, serialized_value) do
    new_value <> serialized_value
  end

  @doc """
  Creates start value of map data, that is specific for current serializer.
  For html serializer it is empty string.
  Used in functions such as Enum.reduce as start value for generating serialized views such as
  <tr><td>id</td><td>text</td></tr><tr><td>id</td><td>text</td></tr>...

  ## Example
  iex> Html.start_value()\n
  ""
  """
  @spec map_start_value :: <<>>
  def map_start_value do
    ""
  end

  @doc """
  Used for updating serialized data.
  Html serializer just passed this data out
  """
  def prepare_result(data) do
    data
  end
end
