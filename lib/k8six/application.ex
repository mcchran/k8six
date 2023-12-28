defmodule K8six.Application do
  use Application

  def start(_type, _args) do
    topologies = [
      default: [
        strategy: Cluster.Strategy.Kubernetes.DNS,
        config: [
          service: "k8six-svc-headless",
          application_name: "k8six"
        ]
      ]
    ]
    children = [
      {Cluster.Supervisor, [topologies, [name: K8six.ClusterSupervisor]]},
      # ..other children..
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: K8six.Supervisor)
  end
end
