.PHONY: start-minikube
start-minikube:
	@minikube start --driver=docker --cpus 8 --memory 8G --addons=metrics-server

.PHONY: install-istio
install-istio:
	@istioctl install -f patches/tracing.yaml --skip-confirmation
	@kubectl apply -f patches/telemetry.yaml
	@kubectl label namespace default istio-injection=enabled --overwrite
	@kubectl apply \
		-f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/prometheus.yaml \
		-f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/kiali.yaml \
		-f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/grafana.yaml \
		-f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/jaeger.yaml
	@kubectl apply -k patches
	@kubectl rollout restart deployment -n istio-system grafana
	@kubectl rollout restart deployment -n istio-system kiali

.PHONY: create-python-app
create-python-app:
	@kubectl apply -k python-app/k8s

.PHONY: test-python-app
test-python-app:
	@./tests/h2load.sh
