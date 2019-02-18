.PHONY: test 


all: test

test:
	docker run -it -v $(CURDIR):/code kubectl-utilization-tests:latest bashcov --skip-uncovered  --root /code -- /usr/local/bin/bats /code/test
	#docker run -it -v $(CURDIR):/code kubectl-utilization-tests:latest kcov --replace-src-path=/code /code/coverage  /usr/local/bin/bats /code/test

