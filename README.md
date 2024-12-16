# WellData FHIR implementation guide

Building this guide requires the following tools:
* Docker

## Running
```shell
docker build . -t welldata && docker run --name=welldata --rm -v ./input:/app/input -v ./output:/app/output  welldata
```

The result can be viewed in the `./output` folder.
