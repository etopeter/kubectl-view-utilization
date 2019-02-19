.PHONY: test 


all: test

test:
	docker run --rm -it -e "CI=true" -v $(CURDIR):/code etopeter/kubectl-utilization-test:latest bashcov --root /code -- /usr/local/bin/bats /code/test
