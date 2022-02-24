# Run tests
test: standard-test
	./hack/test.sh

build:
	./hack/build.sh

standard-test: standard-route-test standard-podspecworkload-test standard-metrics-test standard-autoscaler-test

standard-route-test:
	cd ./traits/routetrait && make test

standard-podspecworkload-test:
	cd ./workloads/podspecworkload && make test

standard-metrics-test:
	cd ./traits/metricstrait && make test

standard-autoscaler-test:
	cd ./traits/autoscalertrait && make test

addon-test:
	bash ./test/e2e-test/hack/addon-vela-test.sh

terraform-addon-gen:
	go run hack/addons/terraform/gen.go $(conf)
