.PHONY: test 


all: test

test-ci:
	docker run --rm -it -e CI=true -e TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST} -v $(CURDIR):/code etopeter/kubectl-utilization-test:latest bashcov --root /code -- /usr/local/bin/bats /code/test

test-ci:
	docker run --rm -it -v $(CURDIR):/code etopeter/kubectl-utilization-test:latest bashcov --root /code -- /usr/local/bin/bats /code/test
