.PHONY: test 


all: test

test:
	docker run -it -v $(CURDIR):/code etopeter/kubectl-utilization-tests:latest bashcov --skip-uncovered  --root /code -- /usr/local/bin/bats /code/test
