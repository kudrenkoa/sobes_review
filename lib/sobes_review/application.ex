defmodule SobesReview.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application
  import SobesReviewWeb.Utils.Cache, only: [init_repo: 1]

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
    sv
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SobesReviewWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def init_cache() do
    import Ecto.Query, only: [from: 2]
    review_count = SobesReview.Repo.one(from r in SobesReview.Review, select: count(r))
    init_repo(%{reviews_count: review_count})
  end
end
