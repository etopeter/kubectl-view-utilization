.PHONY: test 


all: test

test:
	docker run -it -v $(CURDIR):/code etopeter/kubectl-utilization-test:latest /code/test

