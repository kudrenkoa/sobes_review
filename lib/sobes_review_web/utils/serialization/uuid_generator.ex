defmodule SobesReviewWeb.Utils.UUID do
  @doc """
  Generates UUID with Ecto.UUID
  """
  def generate do
    Ecto.UUID.generate
  end
end
