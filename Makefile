.PHONY: test 


all: test build

test:
	docker run --rm -it -v $(CURDIR):/code -w /code etopeter/kubectl-utilization-test:latest bashcov -s --root ./ -- /usr/local/bin/bats test/*.bats

build:
	docker build -t etopeter/kubectl-utilization-test:latest ./test

