defmodule SobesReviewWeb.Utils.Csv do
@moduledoc """
Decodes csv files
"""
  @doc """
  Decodes CSV file via file_path
  Returns list of first line data
  ## Examples
  iex> SobesReviewWeb.Utils.Csv.decode("file.csv")\n
  [1, 2, 3, 4]
  """
  @spec decode(binary) :: list
  def decode(file_path) do
    file_path
    |> read_file
    |> parse_csv
    |> hd
  end

  defp read_file(file_path) do
    File.read(file_path)
  end

  defp parse_csv({:ok, text}) do
    NimbleCSV.define(MyParser, separator: ";", escape: "\"")
    text
    |> MyParser.parse_string
  end
end
