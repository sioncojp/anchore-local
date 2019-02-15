.PHONY: up cve-status list check progress vuln result down clean

help:
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "\033[36m%-22s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST)

##### global
CYAN      := \033[96m
RED       := \033[95m
NC        := \033[0m
DOCKER_COMPOSE := docker-compose exec anchore-engine anchore-cli --u admin --p foobar

up: ## docker up
	-@mkdir db
	@docker-compose pull
	@docker-compose up -d
	@echo "$(CYAN)add local docker registry...$(NC)"
	@sleep 20
	@$(DOCKER_COMPOSE) registry add --insecure anchore-registry.local "" ""

status: ## verify system status
	@$(DOCKER_COMPOSE) system status

cve-status: ## output amount of CVE data on postgres
	@$(DOCKER_COMPOSE) system feeds list

check: require/image ## check image for analyze
	@$(DOCKER_COMPOSE) image add $(IMAGE) --force

progress: require/image ## progress to analyze
	@$(DOCKER_COMPOSE) image get $(IMAGE)  | grep 'Analysis Status'

vuln: require/image
	@$(DOCKER_COMPOSE) image vuln $(IMAGE) all

result: require/image ## result for vulnerability
	@$(DOCKER_COMPOSE) evaluate check $(IMAGE)

push: require/image## push image to local registry
	docker tag $(IMAGE) anchore-registry.local/$(IMAGE)
	docker push anchore-registry.local/$(IMAGE)

down: ## docker down
	@docker-compose down --volumes
	@rm -rf registry/docker

clean: down ## clean all
	rm -f db/*
	rm -f config/analyzer_config.yaml config/anchore_default_bundle.json


##### required
.PHONY: require_*

require/image: err = $(shell echo "$(RED)you must set a argument IMAGE=xxxxx$(NC)")
require/image:
ifeq ($(IMAGE),)
define n


endef
	$(error "$n$n$(err)$n$n")
endif
