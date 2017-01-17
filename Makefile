BRANCH ?= "master"
REPONAME ?= "go-builder"
VERSION ?= $(shell cat ./VERSION)

build-image:
	@docker build -t vidsyhq/${REPONAME} .

build-local:
	@docker build -t vidsyhq/${REPONAME}:local .

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
	@docker login -e ${DOCKER_EMAIL} -u ${DOCKER_USER} -p ${DOCKER_PASS}
	@docker tag vidsyhq/${REPONAME}:latest vidsyhq/${REPONAME}:${CIRCLE_TAG}
	@docker push vidsyhq/${REPONAME}:${CIRCLE_TAG}
	@docker push vidsyhq/${REPONAME}

build: build-local
	@docker run --rm \
	-v "${CURDIR}":/go/src/github.com/vidsy \
	-w /go/src/github.com/vidsy/test-app \
	vidsyhq/go-builder:local \
	@ls -l

test: build
	@docker run -v "${CURDIR}":/app -w /app/test-app alpine ./test-app
