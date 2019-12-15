defmodule SobesReviewWeb.Utils.Cache do
  @moduledoc """
  Module for storing, manipulating and receiving data from Erlang Term Storage
  """

  @doc """
  initializes empty tables for cities and countries in ets and return its names in tuple
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
  initializes two empty tables :counters and :cities,
  tnen adds review count and all cities to that tables
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

  def get_city_id_by_name(name) do
    case :ets.lookup(:cities, name) do
      [{_name, id}] -> id
      [] -> nil
    end
  end

  def insert_city(city) do
    :ets.insert(:cities, {city.name, city.id})
    city
  end

  def get_emotion_id(emotion) do
    [{_name, id}] = :ets.lookup(:emotions, emotion)
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

  @doc """
  Just like increment_reviews_count/0, but returns incoming data
  It's used only for contract in reports_controller

  ## Examples
  iex> increment_reviews_count({:ok, 123})\n
  {:ok, 123}
  iex> increment_reviews_count({:error, :no_file})\n
  {:error, :no_file}
  """
  @spec increment_reviews_count({:ok|:error, any}) :: {:ok|:error, any}
  def increment_reviews_count({:ok, _} = data) do
    :ets.update_counter(:counters, "reviews", 1)
    data
  end

  def increment_reviews_count({:error, _} = error_data) do
    error_data
  end

end
