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
	cp -r addons/ test/e2e-test/addon/testdata/
	cd test/e2e-test/addon/ && \
	   go run mock_server.go && sleep 3 &
	bash ./test/e2e-test/hack/addon-vela-test.sh