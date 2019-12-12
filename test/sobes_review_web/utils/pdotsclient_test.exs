defmodule SobesReviewWeb.UtilsPdotsClientTest do
  use ExUnit.Case
  import SobesReviewWeb.Utils.PdotsClient, only: [get_emotion: 1]

  test "get_emotion correct" do
    assert get_emotion("wow, nice") == "Happy"
  end
  test "get_emotion empty text" do
    assert get_emotion("") == %{"code" => 200, "message" => "empty text"}
  end
end
