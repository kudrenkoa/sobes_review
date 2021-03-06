defmodule SobesReview.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application
  alias SobesReviewWeb.Utils.CacheInitter

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      SobesReview.Repo,
      # Start the endpoint when the application starts
      SobesReviewWeb.Endpoint,
      {Mutex, name: CacheMutex, meta: "mutex string"}
      # Starts a worker by calling: SobesReview.Worker.start_link(arg)
      # {SobesReview.Worker, arg},
    ]
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SobesReview.Supervisor]
    sv = Supervisor.start_link(children, opts)
    CacheInitter.init_cache()
    sv
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SobesReviewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
