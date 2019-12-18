defmodule SobesReviewWeb.Utils.ReviewSerializerBridge do
  @moduledoc """
  Implements generating reports logic
  """
  import SobesReview.Repo, only: [start_transaction_with_callback: 2]
  alias SobesReviewWeb.Utils.SerializerOptions
  alias SobesReviewWeb.Utils.Serializers.{Html, Xlsx}

  @spec create_report(SerializerOptions.t()) :: {:ok | :error, binary}
  def create_report(opts = %SerializerOptions{}) do
    start_transaction_with_callback(opts, &generate_report/2)
  end

  defp generate_report(opts, stream) do
    serializer = get_serializer(opts)

    # data is a map, where keys are a cities/emotions/time/ ets
    # and values are partially serialized review.id and review.text
    # here there is grouping stage into map "data"
    data = Enum.reduce(stream, %{}, fn(review, result_map) ->
      append_result(result_map, review[opts.group_by],
        serializer.one(review), serializer) end)

    data |> Map.keys
    |> Enum.reduce(serializer.start_value(), fn key, acc -> serializer.header(key, data[key])
    |> serializer.join_serialized_values(acc) end)
    |> serializer.prepare_result
  end

  defp get_serializer(options) do
    case options.type do
      :html -> Html
      :xlsx -> Xlsx
    end
  end


  # Checks key in result map, if not - creates in result map this key with empty value, specialized by serializer type.
  # After that uses Map.get_and_update for updating existing map value with new one
  defp append_result(result_map, group_by_key, value, serializer) do
    result_map = if !Map.has_key?(result_map, group_by_key) do
      Map.put(result_map, group_by_key, serializer.map_start_value())
    else result_map
    end

    {_, result_map} = Map.get_and_update(result_map, group_by_key,
      fn(prev_val) -> {"", serializer.update_value(value, prev_val)} end)

    result_map
  end
end
