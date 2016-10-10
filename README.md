<h1 align="center">go-builder</h1>

<p align="center">
  <a href="https://circleci.com/gh/vidsy/go-builder" target="_blank">
    <img src="https://img.shields.io/circleci/project/vidsy/go-builder.svg?maxAge=2592000">
  </a>
  <img src="https://img.shields.io/docker/stars/vidsyhq/go-builder.svg?maxAge=2592000">
  <img src="https://img.shields.io/docker/pulls/vidsyhq/go-builder.svg?maxAge=2592000">
</p>

<p align="center">
  <b>Docker</b> container used to compile <b>Go</b> applications.
</p>

### Versioning

The following apps are versioned in the **Dockerfile**:

- Go
- Glide

### Usage

```bash
docker run --rm -v "$PWD":/go/src/github.com/org/repo -w /go/src/github.com/org/repo vidsyhq/go-builder
```

Replace with correct `$GOPATH`. This will output a binary suitable to use with **Alpine** Linux.

#### Options

Each of the following steps can be controlled with env vars:

* `INSTALL=true` (Installs dependencies using glide).
* `BUILD=true` (Builds the linux 64bit binary).
* `SETUP_SSH=false` (Sets up the ssh config for use in circle CI for private repos).

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

## Vidsy

The engineering team @ [Vidsy.co](http://brands.vidsy.co) write **Go & Ruby microservices**, all deployed to AWS in Docker containers. **Interested?** Ping [@revett](https://github.com/revett)!
