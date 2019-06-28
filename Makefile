IMAGE ?= golang-dev
DOCKERFILE ?= Dockerfile
BUILD_ARGS ?=

# set full image path if given
IMAGE := ${PUBLISH_NAMESPACE}/${IMAGE}
IMAGE := $(IMAGE:/%=%)

# cleanup leading -
TAG := ${TAG}
TAG := $(TAG:-%=%)

# set colon tag (:tag)
ifneq ($(TAG),)
COLON_TAG := :${TAG}
endif

image-build:
	@echo docker image build $(BUILD_ARGS) -t $(IMAGE)$(COLON_TAG) -f $(DOCKERFILE) .
