defmodule SobesReviewWeb.UtilsCsvTest do
  use ExUnit.Case
  import SobesReviewWeb.Utils.Csv, only: [decode: 1]

  test "decode correct file test" do
    correct_test_file = "./correct_test_file.csv"
    correct_test_file
    |> File.write("name;gender;city;text;date\nivan;male;donetsk;great;123")
    right = {:ok, %{city: "donetsk", datetime: DateTime.from_unix!(123), gender: true, name: "ivan", text: "great"}}
    assert decode(correct_test_file) == right
    File.rm(correct_test_file)
  end

  test "nonexistent file decode" do
    assert decode("nonexistent_file") == {:error, :no_file}
  end

  test "empty file decode" do
    correct_test_file = "./correct_test_file.csv"
    correct_test_file
    |> File.write("")
    assert decode(correct_test_file) == {:error, :empty_file}
  end
end
