defmodule SobesReviewWeb.CacheTest do
  use ExUnit.Case
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

    test "get review count" do
      Cache.init_repo(@valid_count, [], [])
      assert Cache.get_reviews_count() == @valid_count
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

  describe "get_reports" do
    test "get_reports_by_type valid report" do
      valid_report = Enum.at(@valid_city_reports, 0)
      :ets.insert(:reports, {:city, valid_report})

      report_from_cache = Cache.get_reports_by_type(:city)
      assert valid_report == report_from_cache
    end

    test "get_reports_by_type empty reports table" do
      valid_report = Enum.at(@valid_city_reports, 0)
      :ets.insert(:reports, {:city, valid_report})

      assert Cache.get_reports_by_type(:emotion) == %{}
    end
  end

  describe "insert_report" do
    @valid_review %{id: 11, text: "wow", gender: false, name: "user_1", city: "London",
      emotion: "Happy", month: 11, time: "12:21"}

    test "insert_report" do
      Cache.insert_report(@valid_review)
      Enum.each(Cache.get_reports_keys(), fn key -> check_valid_report(Cache.get_reports_by_type(key), key) end)
    end

    def check_valid_report(report, selector) do
      key = @valid_review[selector]
      data = Enum.at(report[key], 0)
      assert data.id == @valid_review.id and data.text == @valid_review.text
    end
  end
end
