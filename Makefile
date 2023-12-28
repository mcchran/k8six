KIND_CLUSTER_NAME := k8six
K8S_SRC_FILE := k8six.yaml
IMAGE_NAME := k8six
IMAGE_TAG := latest

.PHONY: create-cluster apply-manifest delete-cluster clean check-kind check-kubectl check-docker build kind-load get-cluster-info

deploy: create-cluster apply-manifest

destroy: delete-cluster

check-kind:
	@command -v kind > /dev/null || (echo "Kind not found. Please install Kind: https://kind.sigs.k8s.io/"; exit 1)

check-kubectl:
	@command -v kubectl > /dev/null || (echo "Kubectl not found. Please install Kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/"; exit 1)

check-docker:
	@command -v docker > /dev/null || (echo "Docker not found. Please install Docker: https://docs.docker.com/get-docker/"; exit 1)

build: check-docker
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

kind-load: check-kind build
	kind load docker-image $(IMAGE_NAME):$(IMAGE_TAG) --name $(KIND_CLUSTER_NAME)

create-cluster: check-kind
	kind create cluster --name $(KIND_CLUSTER_NAME)

apply-manifest: check-kubectl build kind-load
	kubectl apply -f $(K8S_SRC_FILE)

delete-cluster: check-kind
	kind delete cluster --name $(KIND_CLUSTER_NAME)

# support commads
get-cluster-info: check-kubectl
	kubectl cluster-info --context kind-$(KIND_CLUSTER_NAME)

