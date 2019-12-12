defmodule SobesReviewWeb.Utils.PdotsClient do
  @doc """
  Sends post request to apis.paralleldots.com/v4/emotion with text,
  receives all emotions response and returns max emotion by value or
  error tuple %{"code" => code, "message" => message }
  ## Examples
  get_emotion("wow it's super nice!")\n
  iex> "Happy"
  Pdotsproj.get_emotion "that is ugly"\n
  iex> "Fear"
  """
  @spec get_emotion(binary) :: binary | tuple
  def get_emotion(text) when text != "" do
    key = Application.get_env(:app_vars, :pdots_key)
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    {:ok, conn} = Mint.HTTP.connect(:http, "apis.paralleldots.com", 80)
    {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", "/v4/emotion", headers, "text=#{text}&api_key=#{key}")
    receive do
      message ->
        {:ok, conn, responses} = Mint.HTTP.stream(conn, message)
        IO.inspect responses
        [_, _,{:data, _req, emotions}, _] = responses
        res = emotions
        |> Poison.decode!
        |> get_max_emotion
        Mint.HTTP.close conn
        res
    end
  end

  def get_emotion(_text) do
    %{"code" => 200, "message" => "empty text"}
  end

  defp get_max_emotion(%{"emotion" => emotions}) do
    Enum.max_by(emotions, &(elem(&1, 1)))
    |> elem(0)
  end

  defp get_max_emotion(error) do
    error
  end
end
