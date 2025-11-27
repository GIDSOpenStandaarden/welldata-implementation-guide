# WellData FHIR Implementation Guide

This repository contains the FHIR Implementation Guide for the WellData project.

## Prerequisites

* Docker

## Building the Docker Image

```shell
docker build . -t gidsopenstandaarden-welldata-ig
```

## Available Make Targets

| Target | Description |
|--------|-------------|
| `build` | Run the complete FHIR build process (full documentation package) |
| `sushi` | Run SUSHI only (quick FSH validation) |
| `version` | Show the current version from sushi-config.yaml |
| `clean` | Clean build artifacts |
| `help` | Show help message |

## Usage

### Full IG Build

```shell
docker run --rm -v "${PWD}:/src" gidsopenstandaarden-welldata-ig build
```

The result can be viewed in the `./output` folder.

### SUSHI Validation Only

For quick FSH syntax validation without running the full IG publisher:

```shell
docker run --rm -v "${PWD}:/src" gidsopenstandaarden-welldata-ig sushi
```

### Show Help

```shell
docker run --rm -v "${PWD}:/src" gidsopenstandaarden-welldata-ig help
```

## Output Formats

The IG Publisher generates resources in multiple formats:

| Format | Location | Config |
|--------|----------|--------|
| JSON | `output/*.json` | Always generated |
| TTL (RDF) | `output/*.ttl` | `excludettl: false` in sushi-config.yaml |
| XML | `output/*.xml` | `excludexml: false` in sushi-config.yaml |

## GitHub Actions

The guide is automatically built using GitHub Actions. The result is published at:
https://gidsopenstandaarden.github.io/welldata-implementation-guide/
