defmodule SobesReviewWeb.Utils.Validators do
  @moduledoc """
  User file data validation
  """

  @spec validate_decoded_data({:error, any} | {:ok, atom | %{text: any}}) ::
          {:error, any} | {:ok, atom | %{text: any}}
  def validate_decoded_data({:ok, attrs} = data) do
    cond do
      attrs.text == "" or attrs.name == "" or attrs.name == nil or attrs.datetime <= 0 -> {:error, :invalid_data}
      true -> data
    end
  end

  def validate_decoded_data({:error, _} = error) do
    error
  end
end
