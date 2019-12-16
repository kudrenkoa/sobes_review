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
    cities_table_name = init_table :cities, params
    counters_table_name = init_table :counters, params
    emotions_table_name = init_table :emotions, params
    {cities_table_name, counters_table_name, emotions_table_name}
  end

  @doc """
  initializes empty tables :counters, :cities and :emotions,
  tnen inserts data to them. Returns names of the tables
  """
  @spec init_repo(integer, list, list) :: tuple
  def init_repo(review_count, cities, emotions) when review_count >= 0 do
    names = init_repo()
    :ets.insert(:counters, {"reviews", review_count })
    Enum.each(cities, &(insert_city(&1)))
    Enum.each(emotions, &(insert_emotion(&1.id, &1.name)))
    names
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
  def insert_city(city) do
    :ets.insert(:cities, {city.name, city.id})
    city
  end

  @doc """
  Lookups :emotions table for emotion, returns id or nil
  """
  def get_emotion_id(emotion) do
    case :ets.lookup(:emotions, emotion) do
      [{_name, id}] -> id
      _ -> nil
    end
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
