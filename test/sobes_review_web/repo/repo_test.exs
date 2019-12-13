defmodule SobesReviewWeb.RepoTest do
  use ExUnit.Case
  use SobesReview.DataCase
  import SobesReview.Repo, only: [add_review: 1]

  test "add_review" do
    res = %{
      name: "",
      gender: true,
      city: "",
      datetime: DateTime.from_unix!(123),
      text: "text",
    }
    case add_review({:ok, res, "Excited"}) do
      {:ok, _} -> assert true
      {:error, description} -> assert false, inspect description
    end
  end
end
