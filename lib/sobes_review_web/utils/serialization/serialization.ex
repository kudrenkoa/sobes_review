defmodule SobesReviewWeb.Utils.Serialization do
  @moduledoc """
  Logic for reviews serialization
  """
  alias Elixlsx.Sheet
  alias Elixlsx.Workbook
  alias SobesReviewWeb.Utils.UUID

  @doc """
  Serializes reports from cache by type. Returns result {:ok, res},
  where res depends on type - String or excel workbook, stored in memory
  """
  @spec serialize_reports(map, :html | :xlsx) :: {:ok, String.t() | Elixlsx.Workbook.t()}
  def serialize_reports(cached_data, type) do
    res =
    cached_data
    |> Map.keys
    |> Enum.map(fn key -> serialize_inner_cached_data(key, cached_data[key], type) end)
    |> serialize_to(type)

    {:ok, res}
  end

  defp serialize_inner_cached_data(title, values_list, _type = :html) do
    serialized_data = Enum.map(values_list,
      fn element -> "<tr><td>#{element.id}</td><td>#{element.text}</td></tr>" end)
    |> Enum.join()
    "<h1>#{title}</h1><table>#{serialized_data}</table>"
  end

  defp serialize_inner_cached_data(title, values_list, _type = :xlsx) do
    rows = Enum.map(values_list, fn element -> [element.id, element.text] end)
    %Sheet{name: title, rows: rows}
  end

  defp serialize_to(data, :html) do
    Enum.join(data)
  end

  defp serialize_to(data, :xlsx) do
    {_, {_, data}} =
    Enum.reduce(data, %Workbook{}, fn el,
      accum -> Workbook.append_sheet(accum, el) end)
    |> Elixlsx.write_to_memory("/tmp/#{UUID.generate()}.xlsx")
    data
  end
end
