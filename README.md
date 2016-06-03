<h1 align="center">go-builder</h1>

<p align="center">
  <img src="https://circleci.com/gh/vidsy/go-builder/tree/master.svg?style=shield">
  <img src="https://img.shields.io/docker/pulls/vidsyhq/go-builder.svg?maxAge=3600&style=flat">
</p>

<p align="center">
  <b>Docker</b> container used to compile <b>Go</b> applications.
</p>

### Versioning

The following apps are versioned in the **Dockerfile**:

- Go
- Glide

### Usage

```
docker run --rm -v "$PWD":/go/src/github.com/org/repo -w /go/src/github.com/org/repo vidsyhq/go-builder
```

Replace with correct `$GOPATH`. This will output a binary suitable to use with **Alpine** Linux.

### CircleCI

```yaml
machine:
  services:
    - docker

dependencies:
  override:
    - docker run -v "$PWD":/go/src/github.com/org/repo -w /go/src/github.com/org/repo vidsyhq/go-builder
    - docker build -t org/repo .

test:
  override:
    - echo "No tests yet."

deployment:
  hub:
    branch: master
    commands:
      - docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
      - docker push org/repo
```

### Notes

[MIT License (MIT)](https://opensource.org/licenses/MIT)
