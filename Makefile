SOURCEDIR=.
SOURCES := $(shell find $(SOURCEDIR) -name '*.go')
BINARY=maputnik
EDITOR_VERSION ?= v1.7.0
GOPATH := $(if $(GOPATH),$(GOPATH),$(HOME)/go)
GOBIN := $(if $(GOBIN),$(GOBIN),$(HOME)/go/bin)

all: $(BINARY)

$(BINARY): $(GOBIN)/gox $(SOURCES) bindata_assetfs.go
	$(GOBIN)/gox -osarch "windows/amd64 linux/amd64 darwin/amd64" -output "bin/{{.OS}}/${BINARY}"

editor/create_folder:
	mkdir -p editor

editor/pull_release: editor/create_folder
        # if the directory /home/runner/work/editor/editor/build/build exists, we assume that we are are running the makefile within the editor ci workflow
	test -d /home/runner/work/editor/editor/build/build && echo "exists" && cd editor && cp -R /home/runner/work/editor/editor/build/build public/ || (echo "does not exist" && cd editor && rm -rf public && curl -L https://github.com/maputnik/editor/releases/download/$(EDITOR_VERSION)/public.zip --output public.zip && unzip public.zip && rm public.zip)

$(GOBIN)/gox:
	go install github.com/mitchellh/gox@latest

$(GOBIN)/go-bindata:
	go install github.com/go-bindata/go-bindata/...

$(GOBIN)/go-bindata-assetfs: $(GOBIN)/go-bindata
	go install github.com/elazarl/go-bindata-assetfs/...

bindata_assetfs.go: $(GOBIN)/go-bindata-assetfs editor/pull_release
	$(GOBIN)/go-bindata-assetfs -o $@ -prefix "editor/" editor/public/...

.PHONY: clean
clean:
	rm -rf editor/public && rm -f bindata.go && rm -f bindata_assetfs.go && rm -rf bin
