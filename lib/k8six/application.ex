defmodule K8six.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: K8six.Worker.start_link(arg)
      # {K8six.Worker, arg}
      K8six.Observer,
      K8six.Ping
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: K8six.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
