.PHONY: test 


all: test

test:
	docker run --rm -it -v $(CURDIR):/code etopeter/kubectl-utilization-test:latest /usr/local/bin/bats /code/test

