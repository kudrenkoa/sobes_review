defmodule SobesReviewWeb.Utils.ReviewSerializerBridge do
  import SobesReview.Repo, only: [start_transaction_with_callback: 2]
  alias SobesReviewWeb.Utils.ReviewSerializer
  
  @spec create_report({:gender | :city | :emotion | :month | :month | :time,
    :html | :xls}) :: {:ok | :error, binary}
  def create_report({group_by, type}) do
    create_report = case type do
      :html -> &create_html_report/2
      :xls -> &create_excel_report/2
    end
    group_by
    |> start_transaction_with_callback(create_report)
  end

  defp create_html_report(selector, stream) do
    data = Enum.reduce(stream, %{}, fn(review, acc) -> append_result(acc, review[selector], review) end)
    data |> Map.keys
    |> Enum.reduce("", fn key, acc -> ReviewSerializer.get_table(:html, key, data[key]) <> acc end)
  end

  def fff(data) do
    data
    |> Map.keys
    |> Enum.reduce("", fn key, acc -> ReviewSerializer.get_table(:html, key, data[key]) <> acc end)
  end

  defp create_excel_report(_selector, _stream) do

  end

  defp append_result(res, key, review) do
    res = if !Map.has_key?(res, key) do
      Map.put(res, key, "")
    else res
    end
    {_, res} = Map.get_and_update(res, key,
      fn(prev_val) -> {"", prev_val <> ReviewSerializer.serialize_review(:html, review)} end)
    res
  end
end
