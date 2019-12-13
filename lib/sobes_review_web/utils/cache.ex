defmodule SobesReviewWeb.Utils.Cache do
  @moduledoc """
  Module for storing, manipulating and receiving data from Erlang Term Storage,
  """

  @doc """
  Returns number of all reviews, stored in "reviews" table

  ## Examples
  iex> get_reviews_count
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

  iex> increment_reviews_count
  1
  iex> increment_reviews_count
  2
  iex> increment_reviews_count
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
  iex> increment_reviews_count({:ok, 123})
  {:ok, 123}
  iex> increment_reviews_count({:error, :no_file})
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
