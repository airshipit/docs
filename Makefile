# Copyright 2019 AT&T Intellectual Property.  All other rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# VERSION INFO
GIT_COMMIT = $(shell git rev-parse HEAD)
GIT_SHA    = $(shell git rev-parse --short HEAD)
GIT_TAG    = $(shell git describe --tags --abbrev=0 --exact-match 2>/dev/null)
GIT_DIRTY  = $(shell test -n "`git status --porcelain`" && echo "dirty" || echo "clean")

SHELL = /bin/bash

info:
	@echo "Git Tag:           ${GIT_TAG}"
	@echo "Git Commit:        ${GIT_COMMIT}"
	@echo "Git Tree State:    ${GIT_DIRTY}"

.PHONY: all
all: docs

.PHONY: check-tox
check-tox:
	@if [ -z $$(which tox) ]; then \
		echo "Missing \`tox\` client which is required for development"; \
		exit 2; \
	fi

.PHONY: docs
docs: clean build_docs

.PHONY: build_docs
build_docs:
	tox -e docs

.PHONY: clean
clean:
	rm -rf doc/build

# testing checks
.PHONY: tests
tests: check-tox
	tox
