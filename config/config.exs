import Config

config :datapio_cluster,
  service_name: [env: "K8SIX_SERVICE_NAME", default: nil],
  app_name: [env: "K8SIX_APP_NAME", default: "k8six"],
  cache_tables: [
    some_set: [:id, :attr1, :attr2],
    some_other_set: [:id, :attr]
  ]
