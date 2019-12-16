defmodule SobesReviewWeb.Utils.PdotsClient do
  @moduledoc """
  Represents methods for getting emotions from text via apis.paralleldots.com
  """
  @doc """
  Spawns get_emotion in new process, returns pid of new process
  """
  @spec get_emotion_async(String.t, function) :: any
  def get_emotion_async(text, callback) do
    spawn(fn -> get_emotion(text, callback) end)
  end

  @doc """
  Sends post request to apis.paralleldots.com/v4/emotion with text,
  receives all emotions response and calls callback function with max emotion by value
  ## Examples
  iex> get_emotion("very nice!", &(IO.puts(&1)))
  "Happy"
  """
  @spec get_emotion(String.t(), function) :: binary | tuple
  def get_emotion(text, callback) when text != "" do
    api_key = Application.get_env(:app_vars, :pdots_api_key)
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    {:ok, conn} = Mint.HTTP.connect(:http, "apis.paralleldots.com", 80)
    {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", "/v4/emotion", headers, "text=#{text}&api_key=#{api_key}")
    receive do
      message ->
        {:ok, conn, responses} = Mint.HTTP.stream(conn, message)
        [_, _,{:data, _req, emotions}, _] = responses
        max_emotion = emotions
        |> Poison.decode!
        |> get_max_emotion
        callback.(max_emotion)
        Mint.HTTP.close conn
    end
  end

  defp get_max_emotion(%{"emotion" => emotions}) do
    Enum.max_by(emotions, &(elem(&1, 1)))
    |> elem(0)
  end
end
