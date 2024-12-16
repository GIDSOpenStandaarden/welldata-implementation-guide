# WellData FHIR implementation guide

Building this guide requires the following tools:
* Docker

## Building the guide on the local machine
```shell
docker build . -t welldata && docker run --name=welldata --rm -v ./input:/app/input -v ./output:/app/output  welldata
```

The result can be viewed in the `./output` folder.

### Building the guide using github actions
The guide is build using github actions. The result is published on https://gidsopenstandaarden.github.io/welldata-implementation-guide/
