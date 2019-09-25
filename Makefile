default: all

all: kitchen

build: .kitchen.yml

test-only: bundle exec kitchen test

.kitchen.yml: nginx-aws-template.json scripts/build.sh scripts/provision-nginx.sh 
	scripts/build.sh

kitchen-ec2: .kitchen.yml
	bundle exec kitchen test

kitchen: kitchen-ec2

.PHONY: clean
clean:
	bundle exec kitchen destroy