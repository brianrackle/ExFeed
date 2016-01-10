defmodule ExFeed.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, arg) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ExFeed.Server, [arg])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExFeed.Application.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
