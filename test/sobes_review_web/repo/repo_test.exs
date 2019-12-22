defmodule SobesReviewWeb.RepoTest do
  use SobesReview.DataCase, async: true
  alias SobesReview.Repo

  describe "insert_review" do
    @valid_review %{name: "test_user_1", gender: false, text: "test text 1", datetime: DateTime.from_unix!(123)}
    @invalid_review %{name: nil, gender: false, text: "test text 1", datetime: DateTime.from_unix!(123)}

    test "insert_review correct" do
      case Repo.insert_review(@valid_review) do
        {:ok, new_review} -> assert new_review.name == @valid_review.name and
          new_review.gender == @valid_review.gender and new_review.text == @valid_review.text and
          new_review.datetime == @valid_review.datetime
        {:error, description} -> assert false, description
      end
    end

    test "insert_review invalid name" do
      case Repo.insert_review(@invalid_review) do
        {:ok, _} -> assert false, "Somehow incorrect data was inserted"
        {:error, _} -> assert true
      end
    end
  end

  describe "insert_city" do
    @valid_city %{name: "London"}
    @invalid_city %{name: ""}

    test "insert valid city" do
      Repo.insert_city(@valid_city)
      |> case do
        {:ok, new_city} -> assert new_city.name == @valid_city.name
        {:error, err} -> assert false, "Error! #{inspect err}"
      end
    end

    test "insert invalid city" do
      try do
        {:ok, res} = Repo.insert(@invalid_city.name)
        assert false, "Somehow city with invalid name was inserted, result: #{inspect res}"
      rescue
        _e in FunctionClauseError -> assert true
      end
    end
  end

  describe "update_review_city" do
    @valid_review %{name: "test_user_1", gender: false, text: "test text 1", datetime: DateTime.from_unix!(123)}
    @valid_city %{name: "London"}

    test "update_review with correct city" do
      {:ok, new_review} = Repo.insert_review(@valid_review)
      {:ok, new_city} = Repo.insert_city(@valid_city)
      Repo.update_review_city(new_review, new_city.id)
      |> case do
        {:ok, review} -> assert review.city_id == new_city.id
        err -> error_occurred!(err)
      end
    end
  end

  describe "update_review_emotion" do
    @valid_review %{name: "test_user_1", gender: false, text: "test text 1", datetime: DateTime.from_unix!(123)}
    @valid_emotion %{id: 1, name: "Happy"}
    @invalid_emotion %{id: -1, name: "Invalid Emotion"}

    test "update_review with valid emotion" do
      {:ok, new_review} = Repo.insert_review(@valid_review)
      Repo.update_review_emotion(new_review, @valid_emotion.id)
      |> case do
        {:ok, review} -> assert review.emotion_id == @valid_emotion.id
        err -> error_occurred!(err)
      end
    end

    test "update_review with invalid emotion" do
      {:ok, new_review} = Repo.insert_review(@valid_review)
      try do
        Repo.update_review_emotion(new_review, @invalid_emotion.id)
        assert false, "Somehow, emotion with invalid id successfull updated"
      rescue
        _e in Ecto.ConstraintError -> assert true
      end
    end
  end


  defp error_occurred!(err, text \\ "") do
    assert false, "Error! #{text}\nError body: #{err}"
  end


end
