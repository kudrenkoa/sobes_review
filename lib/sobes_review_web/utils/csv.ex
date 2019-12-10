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
    |> get_head
  end

  defp read_file(file_path) do
    file_path |> File.stream!
  end

  defp parse_csv(stream) do
    NimbleCSV.define(MyParser, separator: ";", escape: "\"")
    try do
      {:ok, stream
        |> MyParser.parse_stream
        |> init_review_from_stream
        |> Enum.take(1)}
      rescue
        FunctionClauseError -> {:error, :invalid_file_format}
        File.Error -> {:error, :no_file}
    end
  end

  defp init_review_from_stream(stream) do
    Stream.map(stream, fn [name, gender, city, text, datetime] ->
      %{name: name, gender: check_male_gender(gender),
      city: city, datetime: datetime, text: text}
      end)
  end

  defp check_male_gender(gender) do
    gender == "m" or gender == "true" or gender == "male"
  end

  defp parse_csv(error) do
    error
  end

  defp get_head({:ok, []}) do
    {:error, :empty_file}
  end

  defp get_head({:ok, list}) do
    {:ok, hd list}
  end

  defp get_head(error) do
    error
  end
end
