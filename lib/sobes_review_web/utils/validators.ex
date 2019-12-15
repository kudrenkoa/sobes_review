defmodule SobesReviewWeb.Utils.Validators do
  def validate_decoded_data({:ok, attrs} = data) do
    cond do
      attrs.text == "" or attrs.city == "" -> {:error, :invalid_data}
      true -> data
    end
  end

  def validate_decoded_data({:error, _} = error) do
    error
  end
end
