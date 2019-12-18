defmodule SobesReviewWeb.Utils.ReviewSerializerBridge do
  @moduledoc false
  import SobesReview.Repo, only: [start_transaction_with_callback: 2]
  alias SobesReviewWeb.Utils.SerializerOptions
  alias SobesReviewWeb.Utils.Serializers.{Html}

  @spec create_report(SerializerOptions) :: {:ok | :error, binary}
  def create_report(opts) do
    start_transaction_with_callback(opts, &generate_report/2)
  end

  @spec generate_report(SerializerOptions.t(), Stream) :: String.t()
  defp generate_report(opts, stream) do
    serializer = get_serializer(opts)
    data = Enum.reduce(stream, %{}, fn(review, acc) ->
      append_result(acc, review[opts.group_by], serializer.one(review), serializer) end)
    data |> Map.keys
    |> Enum.reduce(serializer.start_value(), fn key, acc ->
      serializer.header(key, data[key])
      |> serializer.join_serialized_values(acc) end)
  end

  defp get_serializer(options) do
    case options.type do
      :html -> Html
    end
  end

  defp append_result(result_map, group_by_key, value, serializer) do
    result_map = if !Map.has_key?(result_map, group_by_key) do
      Map.put(result_map, group_by_key, serializer.start_value())
    else result_map
    end
    {_, result_map} = Map.get_and_update(result_map, group_by_key,
      fn(prev_val) -> {serializer.start_value(), serializer.append_result(value, prev_val)} end)
      result_map
  end
end
