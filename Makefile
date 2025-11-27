# Makefile for FHIR build process

# Fetch version from sushi-config.yaml with error handling
export VERSION := $(shell grep '^version:' sushi-config.yaml | sed 's/version: //' | tr -d '[:space:]')
ifeq ($(VERSION),)
$(error "Could not extract version from sushi-config.yaml")
endif

# Default target
.PHONY: all
all: build

# Build target (full documentation package)
.PHONY: build
build: build-ig

# Sushi only (for quick FSH validation)
.PHONY: sushi
sushi:
	@echo "Running SUSHI..."
	@sushi .

# Build Implementation Guide (Full with documentation)
.PHONY: build-ig
build-ig:
	@echo "Building Full Implementation Guide with version $(VERSION)..."
	java -jar /usr/local/publisher.jar -ig ig.ini
	@if [ ! -f ./output/package.tgz ]; then \
		echo "ERROR: Build did not create ./output/package.tgz"; \
		exit 1; \
	fi
	@echo "Copying package.tgz to: ./output/welldata-$(VERSION).tgz"
	@cp ./output/package.tgz ./output/welldata-$(VERSION).tgz
	@echo "Successfully created: ./output/welldata-$(VERSION).tgz"

# Show version
.PHONY: version
version:
	@echo "Version: $(VERSION)"

# Clean target
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf output fsh-generated temp

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build    - Run the complete FHIR build process (full documentation package)"
	@echo "  sushi    - Run SUSHI only (quick FSH validation)"
	@echo "  version  - Show the current version from sushi-config.yaml"
	@echo "  clean    - Clean build artifacts"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "TTL files are generated automatically by the IG Publisher in output/"
	@echo "when 'excludettl: false' is set in sushi-config.yaml"
