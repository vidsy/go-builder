<h1 align="center">go-builder</h1>

<p align="center">
  <b>Docker</b> container used to compile <b>Go</b> app.
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

```
TODO: write example circle.yml
```
