defmodule SobesReview.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application
  import SobesReviewWeb.Utils.Cache, only: [init_repo: 3]
  import SobesReview.Repo, only: [get_all_cities: 0, get_reviews_count: 0, get_all_emotions: 0]

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      SobesReview.Repo,
      # Start the endpoint when the application starts
      SobesReviewWeb.Endpoint
      # Starts a worker by calling: SobesReview.Worker.start_link(arg)
      # {SobesReview.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SobesReview.Supervisor]
    sv = Supervisor.start_link(children, opts)
    init_cache()
    # start_refresh_views_process(20000)
    sv
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SobesReviewWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def init_cache() do
    init_repo(get_reviews_count(), get_all_cities(), get_all_emotions())
  end

  defp start_refresh_views_process(sleep_secs) do
    spawn(fn -> refresh_views(sleep_secs) end)
  end

  defp refresh_views(sleep_secs) do
    Process.sleep(sleep_secs)
    SobesReview.Repo.refresh_views
    refresh_views(sleep_secs)
  end
end
