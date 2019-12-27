defmodule Reviewgen do
  def gen_reviews(n) do
    processes = 50
    count = Kernel.trunc(n / processes)
    parent = self()
    for _ <- 1..processes do
      spawn(fn -> insert_in_thread(parent, count) end)
    end

    for _ <- 1..processes do
      receive do
        {:ok, pid} ->
          IO.puts "thread \'#{inspect pid}\' done"
      end
    end
  end

  defp insert_in_thread(pid, count) do
    IO.puts "starting thread #{inspect self()} in 2 secs. count: #{count}"
    Process.sleep(2000)
    Enum.each(1..count, fn (_x) -> insert_random_review() end)
    send pid, {:ok, self()}
  end

  def insert_random_review() do
    Review.Repo.insert!(%Review.Model{
      # city: "city_#{:rand.uniform(1000)}",
      datetime: DateTime.from_unix!(:rand.uniform(100000)),
      gender: true,
      name: "name_#{:rand.uniform(1000)}",
      text: gen_text(:rand.uniform(150)),
      emotion_id: :rand.uniform(5),
      city_id: :rand.uniform(4)
    })
  end

  defp gen_text(number) do
    cond do
      number <= 50 -> "wow!"
      number > 50 and number <= 100 -> "not bad"
      number <= 150 -> "fuuuu"
    end
  end

  def spawn_check() do
    send(self(), "message")
    spawn(fn -> sleep_ins()  end)
    IO.puts "function spawned!"
  end

  defp sleep_ins() do
    secs = 2000
    IO.puts "sleeping for #{secs}"
    Process.sleep(secs)
    insert_random_review()
  end
end
