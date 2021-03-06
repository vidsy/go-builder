BRANCH ?= "master"
REPONAME ?= "go-builder"
VERSION ?= $(shell cat ./VERSION)

build-image:
	@docker build -t vidsyhq/${REPONAME} --build-arg VERSION=${VERSION} .

build-image-local:
	@docker build -t vidsyhq/${REPONAME}:local --build-arg VERSION=${VERSION} .

check-version:
	@echo "=> Checking if VERSION exists as Git tag..."
	(! git rev-list ${VERSION})

push-tag:
	@echo "=> New tag version: ${VERSION}"
	git checkout ${BRANCH}
	git pull origin ${BRANCH}
	git tag ${VERSION}
	git push origin ${BRANCH} --tags

push-to-registry:
	@docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
	@docker tag vidsyhq/${REPONAME}:latest vidsyhq/${REPONAME}:${CIRCLE_TAG}
	@docker push vidsyhq/${REPONAME}:${CIRCLE_TAG}
	@docker push vidsyhq/${REPONAME}

build: build-image-local
	@docker run --rm \
	-v "${CURDIR}/src/github.com/vidsy":/go/src/github.com/vidsy \
	-w /go/src/github.com/vidsy/test-app-modules \
	vidsyhq/go-builder:local \
	@ls -l

test: build
	@docker run --rm=true \
	-v "${CURDIR}/src/github.com/vidsy/test-app-modules":/test-app-modules \
	-w /test-app-modules alpine \
	./test-app-modules
