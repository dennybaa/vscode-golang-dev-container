IMAGE ?= golang-dev
DOCKERFILE ?= Dockerfile
DOCKER_BUILDARGS ?=

BUILD_TOOLS := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))/build/tools

## Dbtag semver tagging tool
#
DBTAG ?= $(BUILD_TOOLS)/dbtag
DBTAG_VER ?= v0.1.2
DBTAG_URL ?= https://github.com/stackfeed/dbtag/releases/download/$(DBTAG_VER)/dbtag-linux-amd64
DBTAG_SUM := 309a26d2cb427259eeeaa9da39a1eae9cd74baa9a9bbd6d7c34535e269c1a80c

## Fetch macros to download a file using curl or wget (no overwrite)
#
define fetch
	@ FETCH=$$(which curl || which wget) && FETCH=$$(basename $$FETCH) && \
	case $$FETCH in \
	curl) \
		[ -f $(2) ] || ( echo "Downloading $(1) ..." && curl -sSL -o $(2) $(1) ) ;; \
	wget) \
		[ -f $(2) ] || ( echo "Downloading $(1) ..." && wget -O $(2) $(1) ) ;; \
	*) \
		>&2 echo "No curl or wget available!" && \
		exit 1 ;; \
	esac
endef

build-tools:
	@mkdir -p $(BUILD_TOOLS)
	$(call fetch,$(DBTAG_URL),$(DBTAG))

	cd $(BUILD_TOOLS) && printf "$(DBTAG_SUM)  dbtag" | sha256sum -c

build-tools-cleanup:
	@mkdir -p $(BUILD_TOOLS)
	@cd $(BUILD_TOOLS) && ls -1a | sed '1,2d' | xargs -I{} -n1 echo rm -rf {}

image-build:
	docker image build $(DOCKER_BUILDARGS) -t $(IMAGE) -f $(DOCKERFILE) .

image-name:
	@echo -n $(IMAGE)
