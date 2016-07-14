# vim: noexpandtab filetype=make
SHELL:=/usr/bin/env bash
ORG:=bigvikinggames
DOCKER:=docker
PUSH:=false

# HAHA! I lied there is a default task!
default:
	@echo "Please read Makefile, there is no default task!"

.PHONY: ubuntu notebook nodejs postgres gitlab-runner java flyway airflow node-red ratticdb sentry php-fpm ruby cachet cachet-monitor

all: ubuntu python java flyway airflow nodejs node-red postgres gitlab-runner cachet cachet-monitor

ubuntu notebook nodejs postgres gitlab-runner php-fpm ruby cachet-monitor:
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

python: ubuntu
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

java: ubuntu
	$(DOCKER) build -t $(ORG)/$(@):openjdk-7 ./$(@)/openjdk-7/
	$(DOCKER) build -t $(ORG)/$(@):openjdk-8 ./$(@)/openjdk-8/
	$(DOCKER) tag -f $(ORG)/$(@):openjdk-8 $(ORG)/$(@):latest
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
		$(DOCKER) push $(ORG)/$(@):openjdk-7; \
		$(DOCKER) push $(ORG)/$(@):openjdk-8; \
	fi;

flyway: java
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

airflow: python
	$(DOCKER) build -t $(ORG)/$(@):1.6 --build-arg AIRFLOW_VERSION='1.6,<1.7' ./$(@)/
	$(DOCKER) build -t $(ORG)/$(@):1.7 --build-arg AIRFLOW_VERSION='1.7,<1.8' ./$(@)/
	$(DOCKER) tag -f $(ORG)/$(@):1.7 $(ORG)/$(@):latest
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
		$(DOCKER) push $(ORG)/$(@):1.6; \
		$(DOCKER) push $(ORG)/$(@):1.7; \
	fi;

ratticdb: python
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

sentry: python
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

node-red: nodejs
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

cachet: php-fpm
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;
