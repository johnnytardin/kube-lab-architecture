# Makefile

TF_BIN ?= terraform
TF_LOCAL_BIN ?= terraform
TERRAFORM_S3_PRODUCTION_STATE_BUCKET ?=
TERRAFORM_S3_STATE_PATH ?= state/eks
CURRENT_DIR := $(shell pwd)
KUBECONFIG := $(CURRENT_DIR)/.kubeconfig/kubeconfig.yaml

.PHONY: all kyverno kyverno-test kubearmor kubearmor-test terraform-init terraform-plan terraform-apply terraform-local k3s-start k3s-stop k3s-clean localstack-start localstack-stop localstack-clean set-env eks-getconfig deploy-test argocd-secret

all: kyverno-install kubearmor terraform-init terraform-apply k3s-start localstack-start set-env eks-getconfig

kyverno-install:
	@echo "Installing Kyverno..."
	helm repo add kyverno https://kyverno.github.io/kyverno/
	helm repo update
	helm install kyverno kyverno/kyverno -n kyverno --create-namespace

kyverno-test:
	@echo "Running Kyverno tests..."
	kubectl create ns kyverno-test
	kubectl apply -f tests/kyverno/pod-without-env-label.yaml -n kyverno-test
	kubectl describe pod nginx -n kyverno-test
	kubectl delete ns kyverno-test

kubearmor-test:
	@echo "Running KubeArmor tests..."
	kubectl create ns kubearmor-test
	kubectl apply -f tests/kubearmor/block-sleep.yaml -n kubearmor-test
	kubectl run test-sleep -ti --rm --image=nginx --labels="env=sandbox" -- /bin/sleep 5
	kubectl delete ns kubearmor-test

terraform-init:
	@echo "Setting up Terraform..."
	$(TF_BIN) init \
	    -backend-config="bucket=$(TERRAFORM_S3_PRODUCTION_STATE_BUCKET)" \
	    -backend-config="key=$(TERRAFORM_S3_STATE_PATH)"

terraform-plan:
	@echo "Planning Terraform..."
	$(TF_BIN) plan

terraform-apply:
	@echo "Applying Terraform..."
	$(TF_BIN) apply

terraform-local:
	@echo "Applying Terraform configuration with local backend..."
	$(TF_LOCAL_BIN) init -backend=false
	$(TF_LOCAL_BIN) apply -auto-approve

k3s-start:
	@echo "Starting k3s..."
	docker compose -f docker-compose.k3s.yml up -d

k3s-stop:
	@echo "Stopping k3s..."
	docker compose -f docker-compose.k3s.yml down

k3s-clean:
	@echo "Cleaning k3s..."
	docker compose -f docker-compose.k3s.yml down -v

localstack-start:
	@echo "Starting Localstack..."
	docker compose -f docker-compose.localstack.yml up -d

localstack-stop:
	@echo "Stopping Localstack..."
	docker compose -f docker-compose.localstack.yml down

localstack-clean:
	@echo "Cleaning Localstack..."
	docker compose -f docker-compose.localstack.yml down -v

set-env:
	@echo "Setting environment variables..."
	@export KUBECONFIG=$(KUBECONFIG)

eks-getconfig:
	aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}

deploy-test:
	# Go to https://github.com/johnnytardin/kube-lab
	helm install kube-lab deploy/ --namespace kube-lab --create-namespace
	curl -H "Host: kube-lab.local" http://localhost

argocd-secret:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

argocd-forward:
	kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443
