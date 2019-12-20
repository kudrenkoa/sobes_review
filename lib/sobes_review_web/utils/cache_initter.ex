defmodule SobesReviewWeb.Utils.CacheInitter do
  import SobesReviewWeb.Utils.Cache, only: [init_repo: 3, get_reports_keys: 0, init_report_table_by_type: 2]
  import SobesReview.Repo, only: [get_all_cities: 0, get_reviews_count: 0, get_all_emotions: 0, start_transaction_with_callback: 2]

  def init_cache() do
    init_repo(get_reviews_count(), get_all_cities(), get_all_emotions())
    Enum.each(get_reports_keys(), fn key ->
      spawn(fn -> start_transaction_with_callback(%{group_by: key}, &db_callback/2) end)
    end)
    # Enum.each(get_reports_keys(), &(
    #   &1
    #   |> get_views_by_opts
    #   |> init_report_table_by_type(&1)
    # ))
  end

  defp db_callback(opts, stream) do
    Enum.reduce(stream, %{}, &(
      add_review_to_map(&2, &1, opts.group_by)
    ))
    |> init_report_table_by_type(opts.group_by)
    # Enum.map(stream, &(
    #   %{id: &1.id, text: &1.text, value: &1[opts.group_by]}
    # ))
    # |> init_report_table_by_type(opts.group_by)
  end

  defp add_review_to_map(result_map, review, selector) do
    result_map = if Map.get(result_map, review[selector]) do
      result_map
    else
      Map.put(result_map, review[selector], [])
    end

    {_ , result_map } = Map.get_and_update(result_map, review[selector], &(
      {"", [%{id: review.id, text: review.text} | &1 ]}
    ))

    result_map
  end
end
