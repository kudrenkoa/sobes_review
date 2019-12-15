defmodule SobesReviewWeb.Utils.PdotsClient do
  @moduledoc """
  Represents methods for getting emotions from text via apis.paralleldots.com
  """
  def add_emotion_async(review, text, callback) do
    spawn_link(fn -> get_emotion(review, text, callback) end)
    {:ok, review}
  end
  def add_emotion({:ok, %{text: ""}}) do
    {:error, :no_review_text}
  end

  def add_emotion({:error, _err} = error) do
    error
  end

  @doc """
  Sends post request to apis.paralleldots.com/v4/emotion with text,
  receives all emotions response and returns max emotion by value or
  error tuple %{"code" => code, "message" => message }
  ## Examples

  """
  @spec get_emotion(map, String.t(), any) :: binary | tuple
  def get_emotion(review, text, callback) when text != "" do
    api_key = Application.get_env(:app_vars, :pdots_api_key)
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    {:ok, conn} = Mint.HTTP.connect(:http, "apis.paralleldots.com", 80)
    {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", "/v4/emotion", headers, "text=#{text}&api_key=#{api_key}")
    receive do
      message ->
        {:ok, conn, responses} = Mint.HTTP.stream(conn, message)
        IO.inspect responses
        [_, _,{:data, _req, emotions}, _] = responses
        |> Poison.decode!
        |> get_max_emotion
        Mint.HTTP.close conn
        callback.(review, emotions)
    end
  end

  defp get_max_emotion(%{"emotion" => emotions}) do
    Enum.max_by(emotions, &(elem(&1, 1)))
    |> elem(0)
  end

  defp get_max_emotion(_error) do
    {:error, :paralleldots_error}
  end
end
