.PHONY: test 


all: test

test:
	docker run -it -e "CI=true" -v $(CURDIR):/code etopeter/kubectl-utilization-test:latest bashcov --skip-uncovered  --root /code -- /usr/local/bin/bats /code/test
