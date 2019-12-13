defmodule SobesReview.RepoErrorConverter do
  def convert(_errors) do
    [name: {"can't be blank", [validation: :required]}, city: {"can't be blank", [validation: :required]}]
    |> Enum.map(fn {x, {descr, _}} -> "#{x}: #{descr}" end)
    |> Enum.join("\n")
  end
end
