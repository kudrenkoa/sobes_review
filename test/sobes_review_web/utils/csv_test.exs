defmodule SobesReviewWeb.UtilsCsvTest do
  use ExUnit.Case
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]
  # doctest SobesReviewWeb.Utils.Csv

  test "decode correct file test" do
    correct_test_file = "./correct_test_file.csv"
    correct_test_file
    |> File.write("name;gender;city;text;date\nivan;male;donetsk;great;123")
    assert decode(correct_test_file) == {:ok, ["ivan", "male", "donetsk", "great", "123"]}
    File.rm(correct_test_file)
  end

  test "nonexistent file decode" do
    assert decode("nonexistent_file") == {:error, :enoent}
  end

  test "empty file decode" do
    correct_test_file = "./correct_test_file.csv"
    correct_test_file
    |> File.write("")
    assert decode(correct_test_file) == {:error, :emptyfile}
  end
end
