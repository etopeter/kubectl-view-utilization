.PHONY: test 


all: test

test-ci:
	docker run --rm -it -e CI=true -e TRAVIS_BRANCH=${TRAVIS_BRANCH} -e TRAVIS_COMMIT=${TRAVIS_COMMIT} -v $(CURDIR):/code etopeter/kubectl-utilization-test:latest bashcov --root /code -- /usr/local/bin/bats /code/test

test-ci:
	docker run --rm -it -v $(CURDIR):/code etopeter/kubectl-utilization-test:latest bashcov --root /code -- /usr/local/bin/bats /code/test
