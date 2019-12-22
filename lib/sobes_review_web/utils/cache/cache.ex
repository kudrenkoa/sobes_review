defmodule SobesReviewWeb.Utils.Cache do
  @moduledoc """
  Module for storing, manipulating and receiving data from Erlang Term Storage
  """

  @doc """
  initializes empty tables for cities, counters and emotions in :ets and returns its names in tuple
  ## Examples
  iex> init_repo(%{reviews_count: 123})\n
  {:cities, :counters}
  """
  @spec init_repo() :: tuple
  def init_repo() do
    params = [:set, :public, :named_table]
    table_names = [:cities, :counters, :emotions, :reports]
    Enum.each(table_names, &(init_table(&1, params)))
    {:ok}
  end

  @doc """
  initializes empty tables :counters, :cities and :emotions,
  tnen inserts data to them. Returns names of the tables
  """
  @spec init_repo(integer, list, list) :: tuple
  def init_repo(review_count, cities, emotions) when review_count >= 0 and is_list(cities) and is_list(emotions) do
    init_repo()
    :ets.insert(:counters, {"reviews", review_count })
    Enum.each(cities, &(insert_city(&1)))
    Enum.each(emotions, &(insert_emotion(&1.id, &1.name)))
    {:ok}
  end

  @doc """
  Inserts reports by reports type to :ets

  ## Examples
  iex> init_report_table_by_type([%{}, %{}], :city)
  :ok
  """
  def init_report_table_by_type(reports, type) do
    :ets.insert(:reports, {type, reports})
  end

  @doc """
  Adds data from review into reports tables. Returns review by itself
  """
  def insert_report(review) do
    lock = Mutex.await(CacheMutex, review.id)
    Enum.each(get_reports_keys(), fn key ->
      insert_into_reports_table(key, review.id, review.text, review[key]) end)
    Mutex.release(MyMutex, lock)
    review
  end

  # adds new data into reports table
  defp insert_into_reports_table(type, id, text, value) do
    reports_map = get_reports_by_type(type)

    {_, reports_map} = reports_map
    |> init_map_key_if_not_exists(value)
    |> Map.get_and_update(value, fn val -> {val, [%{id: id, text: text} | val]} end)
    :ets.insert(:reports, {type, reports_map})
  end

  @doc """
  return add data from reports by specific type
  """
  def get_reports_by_type(type) do
     :ets.lookup(:reports, type)
    |> case  do
      [{_, res}] -> res
      [] -> %{}
    end
  end

  defp init_map_key_if_not_exists(map, key) do
    if Map.get(map, key) do
      map
    else
      Map.put(map, key, [])
    end
  end

  @spec get_reports_keys :: [:city | :emotion | :gender | :month | :time, ...]
  def get_reports_keys() do
    [:city, :emotion, :gender, :month, :time]
  end

  defp init_table(name, params) when is_atom(name) do
    case :ets.whereis name do
     :undefined -> :ets.new name, params
     _ -> re_init_table name, params
    end
  end

  defp re_init_table(name, params) do
    :ets.delete name
    :ets.new(name, params)
  end

  @doc """
  Gets city id from :cities table if exists. else returns nil
  ## Examples
  iex> get_city_id_by_name "London"
  12
  iex> get_city_id_by_name "not existing city"
  nil
  """
  def get_city_id_by_name(name) do
    case :ets.lookup(:cities, name) do
      [{_name, id}] -> id
      [] -> nil
    end
  end
  @doc """
  Inserts city into a :cities table. returns city
  """
  def insert_city(city) when is_map(city) do
    :ets.insert(:cities, {city.name, city.id})
    city
  end

  @doc """
  Lookups :emotions table for emotion, returns id or nil
  """
  def get_emotion_id(emotion) do
    case :ets.lookup(:emotions, emotion) do
      [{_name, id}] -> id
      _ -> get_undefined_emotion()
    end
  end

  defp get_undefined_emotion() do
    [{_, id}] = :ets.lookup(:emotions, "undef")
    id
  end

  defp insert_emotion(id, name) do
    :ets.insert(:emotions, {name, id})
  end

  @doc """
  Returns number of all reviews, stored in "reviews" table

  ## Examples
  iex> get_reviews_count\n
  10
  """
  @spec get_reviews_count :: integer
  def get_reviews_count() do
    [{_, value}] = :ets.lookup(:counters, "reviews")
    value
  end

  @doc """
  increments review count via :ets.update_counter
  ## Examples

  iex> increment_reviews_count\n
  1
  iex> increment_reviews_count\n
  2
  iex> increment_reviews_count\n
  3
  """
  @spec increment_reviews_count :: integer
  def increment_reviews_count() do
    :ets.update_counter(:counters, "reviews", 1)
  end
end
