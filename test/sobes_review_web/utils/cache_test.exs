defmodule SobesReviewWeb.CacheTest do
  use ExUnit.Case, async: true
  alias SobesReviewWeb.Utils.Cache

  setup %{} do
    Cache.init_repo()
    :ok
  end

  describe "init_repo" do
    @valid_count 5
    @invalid_count -1
    @valid_city_reports %{"London" => [%{id: 1, text: "super!"}, %{id: 3, text: "fuu"}],
      "Paris" => [%{id: 55, text: "wow"}]}

    test "init_repo valid count" do
      Cache.init_repo(@valid_count, [], [])
      [{_, count}] = :ets.lookup(:counters, "reviews")
      assert count == @valid_count
    end

    test "init_repo invalid count" do
      try do
        Cache.init_repo(@invalid_count, [], [])
        assert false, "Somehow cache with invalid reviews_count was initialized"
      rescue
        _e in FunctionClauseError -> assert true
      end
    end

    test "init_report_table_by_type" do
      Cache.init_report_table_by_type(@valid_city_reports, :city)
      [{_, reports}] = :ets.lookup(:reports, :city)
      assert Map.has_key?(reports, "London") and Map.has_key?(reports, "Paris")
    end
  end

  describe "insert_city" do
    @valid_city %{id: 1, name: "London"}

    test "insert_city" do
      Cache.insert_city(@valid_city)
      :ets.lookup(:cities, @valid_city.name)
      |> case  do
        [{name, id}] -> assert @valid_city.name == name and @valid_city.id == id
        _ -> assert false
      end
    end
  end
end
