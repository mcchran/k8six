defmodule K8six.MixProject do
  use Mix.Project

  def project do
    [
      app: :k8six,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :datapio_cluster],
      mod: {K8six.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {
        :datapio_cluster,
        github: "datapio/opencore",
        ref: "main",
        sparse: "apps/datapio_cluster"
      }
    ]
  end
end
