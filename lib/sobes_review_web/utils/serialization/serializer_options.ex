defmodule SobesReviewWeb.Utils.SerializerOptions do
  @moduledoc """
  Stores data for serialization: group_by can be :city, :emotion, etc and type is :html or :xlsx
  """
  defstruct group_by: :nil, type: :nil
end
