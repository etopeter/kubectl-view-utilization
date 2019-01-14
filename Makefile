.PHONY: test 


current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))


all: test


test:
	docker run -it -v $(CURDIR):/code etopeter/kubectl-utilization-test:latest /code/test

