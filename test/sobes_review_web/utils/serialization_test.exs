defmodule SobesReviewWeb.SerializationTest do
  use ExUnit.Case, async: true
  alias SobesReviewWeb.Utils.Serialization
  alias Elixlsx.Sheet
  alias Elixlsx.Workbook
  # import SobesReviewWeb.Utils.UUID

  @valid_city_reports %{"London" => [%{id: 1, text: "super!"}, %{id: 3, text: "fuu"}],
  "Paris" => [%{id: 55, text: "wow"}]}

  test "serialize to html" do
    {:ok, serialized_report} = Serialization.serialize_reports(@valid_city_reports, :html)
    assert serialized_report == "<h1>London</h1><table><tr><td>1</td><td>super!</td></tr><tr><td>3</td><td>fuu</td></tr></table><h1>Paris</h1><table><tr><td>55</td><td>wow</td></tr></table>"
  end

  test "serialize to xlsx" do
    {:ok, {_name, wb_bin}} = Enum.map(Map.keys(@valid_city_reports),
      fn city -> init_sheet(city, @valid_city_reports[city]) end)
    |> Enum.reduce( %Workbook{}, fn sheet, wb -> Workbook.append_sheet(wb, sheet) end)
    |> Elixlsx.write_to_memory("/tmp/temp_workbook")
    {:ok, serialized_report} = Serialization.serialize_reports(@valid_city_reports, :xlsx)
    assert serialized_report == wb_bin
  end

  def init_sheet(city, data) do
    rows = Enum.map(data, fn dt -> [dt.id, dt.text] end)
    %Sheet{name: city, rows: rows}
  end
end
