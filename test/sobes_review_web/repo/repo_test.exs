defmodule SobesReviewWeb.RepoTest do
  use ExUnit.Case
  use SobesReview.DataCase
  import SobesReview.Repo, only: [add_review: 1, insert_city: 1, get_city: 1]

  test "add_review correct" do
    c = "Paris"
    emotion = "Excited"
    res = %{
      name: "ivan",
      gender: true,
      city: c,
      datetime: DateTime.from_unix!(123),
      text: "text",
    }
    # IO.inspect add_review({:ok, res, emotion})

    case add_review({:ok, res, emotion}) do
      {:ok, _} -> assert true
      {:error, description} -> assert false, description
    end
  end

  test "add_review incorrect name" do
    emotion = "Excited"
    res = %{
      gender: true,
      city: "donetsk",
      datetime: DateTime.from_unix!(123),
      text: "text",
    }
    # IO.inspect add_review({:ok, res, emotion})

    case add_review({:ok, res, emotion}) do
      {:ok, _} -> assert false, "Somehow incorrect data was inserted"
      {:error, _} -> assert true
    end
  end

  test "add_review incorrect emotion" do
    emotion = "qwerty"
    res = %{
      name: "ivan",
      gender: true,
      city: "donetsk",
      datetime: DateTime.from_unix!(123),
      text: "text",
    }
    case add_review({:ok, res, emotion}) do
      {:ok, _} -> assert false, "Somehow incorrect data was inserted"
      {:error, _} -> assert true
    end
  end
end
