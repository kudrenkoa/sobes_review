defmodule SobesReviewWeb.Utils.Serializers.Xlsx do
  alias Elixlsx.Sheet
  alias Elixlsx.Workbook
  alias SobesReviewWeb.Utils.UUID
  @moduledoc """
  Logic of Xlsx review serializer
  """

  @doc """
  Generates list for review id and text for further adding to Sheet

  ## Examples
  iex> Xlsx.one(%{id: 1, text: "super cool!"})
  [1, "super cool!"]
  """
  @spec one(%{id: any, text: any}) :: [...]
  def one(review) do
    [review.id, review.text]
  end

  @doc """
  Initializes new Sheet with name: title and rows: inner_parts

  ## Examples
  iex> Xlsx.header("Tokyo", [1, "super!"])
  %Elixlsx.Sheet{
    col_widths: %{},
    group_cols: [],
    group_rows: [],
    merge_cells: [],
    name: "Tokyo",
    pane_freeze: nil,
    row_heights: %{},
    rows: [1, "super!"],
    show_grid_lines: true
  }
  """
  def header(title, inner_parts) do
    %Sheet{name: title, rows: inner_parts}
  end

  @doc """
  Creates start value of resulting data, that is specific for current serializer.
  For xlsx serializer it is empty %Elixlsx.Workbook{}.
  Used in functions such as Enum.reduce as start value for generating result of all serialization

  ## Examples
  iex> start_value()
  %Elixlsx.Workbook{datetime: nil, sheets: []}
  """
  def start_value do
    %Workbook{}
  end

  @doc """
  Joins two serialized values into one.
  For Xlsx serializer this function appends workbook sheets with sheet

  ## Examples
  iex> join_serialized_values %Workbook{}, %Sheet{name: "Tokyo", rows: [1, "super!"]}
  %Elixlsx.Workbook{
    datetime: nil,
    sheets: [
      %Elixlsx.Sheet{
        col_widths: %{},
        group_cols: [],
        group_rows: [],
        merge_cells: [],
        name: "Tokyo",
        pane_freeze: nil,
        row_heights: %{},
        rows: [1, "super!"],
        show_grid_lines: true
      }
    ]
  }
  """
  def join_serialized_values(sheet, workbook) do
    Workbook.append_sheet(workbook, sheet)
  end

  @doc """
  Added new value to serialized_value list
  Used in grouping serialized values in map
  """
  @spec update_value(any, list) :: list
  def update_value(new_value, serialized_value) do
    [new_value | serialized_value]
  end

  @doc """
  Creates start value of map data, that is specific for current serializer.
  For xlsx serializer it is empty list.
  Used in functions such as Enum.reduce as start value for generating serialized views
  """
  def map_start_value do
    []
  end

  @doc """
  Generates in-memory .xlsx file with random name and returns this file
  """
  def prepare_result(workbook) do
    name = "/tmp/#{UUID.generate()}.xlsx"
    {_, {_, data}} = Elixlsx.write_to_memory(workbook, name)
    data
  end
end
