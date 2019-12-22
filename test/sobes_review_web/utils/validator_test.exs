defmodule SobesReviewWeb.ValidatorsTest do
  use ExUnit.Case, async: true
  alias SobesReviewWeb.Utils.Validators

  @valid_review %{name: "test_user_1", gender: false, text: "test text 1", datetime: DateTime.from_unix!(123)}
  @invalid_review %{name: nil, gender: false, text: "test text 1", datetime: -1}

  test "validate valid decoded review data" do
    assert Validators.validate_decoded_data({:ok, @valid_review}) == {:ok, @valid_review}
  end

  test "validate invalid decoded review data" do
    assert Validators.validate_decoded_data({:ok, @invalid_review}) == {:error, :invalid_data}

    # try do

    # end
  end

end
