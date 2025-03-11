# WellData FHIR implementation guide

Building this guide requires the following tools:
* Docker

## Building the guide on the local machine
```shell
docker build . -t gidsopenstandaarden-welldata-ig && docker run -v ./input:/app/input -v ./output:/app/output -v ./tmp:/tmp/ -v ./root:/root  -it gidsopenstandaarden-welldata-ig
```

The result can be viewed in the `./output` folder.

### Building the guide using github actions
The guide is build using github actions. The result is published on https://gidsopenstandaarden.github.io/welldata-implementation-guide/
