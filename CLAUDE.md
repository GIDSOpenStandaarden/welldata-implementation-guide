# WellData FHIR Implementation Guide

## Project Overview

This is a FHIR R4 Implementation Guide for the WellData project, which enables personal health data storage in Solid pods with FHIR-based access.

## Technology Stack

- **FHIR Shorthand (FSH)**: Profiles and examples defined in `input/fsh/`
- **SUSHI**: FSH compiler
- **HL7 FHIR IG Publisher**: Generates the full Implementation Guide
- **Docker**: Build environment

## Project Structure

```
├── input/
│   ├── fsh/
│   │   ├── profiles/          # FHIR profile definitions (FSH)
│   │   └── instances/         # Example instances (FSH)
│   ├── pagecontent/           # Markdown documentation pages
│   └── images-source/         # PlantUML diagrams
├── sushi-config.yaml          # SUSHI/IG configuration
├── ig.ini                     # IG Publisher configuration
├── Makefile                   # Build targets
├── Dockerfile                 # Build environment
└── docker-entrypoint.sh       # Docker entry point
```

## Build Commands

All builds use Docker. First build the image:

```shell
docker build . -t gidsopenstandaarden-welldata-ig
```

Then run targets:

```shell
# Full IG build (generates HTML, JSON, TTL)
docker run --rm -v "${PWD}:/src" gidsopenstandaarden-welldata-ig build

# SUSHI only (quick FSH validation)
docker run --rm -v "${PWD}:/src" gidsopenstandaarden-welldata-ig sushi

# Show available targets
docker run --rm -v "${PWD}:/src" gidsopenstandaarden-welldata-ig help
```

## Key Configuration

In `sushi-config.yaml`:
- `FSHOnly: false` - Generate full IG structure
- `excludettl: false` - Generate TTL (RDF) output
- `excludexml: true` - Skip XML output

## FHIR Profiles

| Profile | File | Description |
|---------|------|-------------|
| WellDataPatient | `profiles/WellDataPatient.fsh` | Patient demographic data |
| WellDataObservation | `profiles/WellDataObservation.fsh` | Health observations (vitals, lab results, surveys) |
| WellDataQuestionnaire | `profiles/WellDataQuestionnaire.fsh` | Questionnaire definitions |
| WellDataQuestionnaireResponse | `profiles/WellDataQuestionnaireResponse.fsh` | Questionnaire answers |

## Adding Examples

Add FSH instances in `input/fsh/instances/`. Example:

```fsh
Instance: example-new-observation
InstanceOf: WellDataObservation
Title: "New Observation Example"
* status = #final
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #12345678
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:00:00+02:00"
* valueQuantity.value = 100
* valueQuantity.unit = "mg/dL"
```

## Adding Documentation Pages

1. Create markdown file in `input/pagecontent/`
2. Add to `pages:` section in `sushi-config.yaml`
3. Add to `menu:` section in `sushi-config.yaml`

## PlantUML Diagrams

Place `.plantuml` files in `input/images-source/`. Reference in markdown:

```markdown
{::nomarkdown}
{% include diagram-name.svg %}
{:/}
```

## Output

After `make build`, output is in `output/`:
- `*.html` - Documentation pages
- `*.json` - FHIR resources as JSON
- `*.ttl` - FHIR resources as RDF/Turtle
- `package.tgz` - FHIR package for distribution

## Git Conventions

- Do not commit `output/`, `fsh-generated/`, `temp/`, `input-cache/`
- Use `git rm -f` for deletions, `git mv` for moves
- Add new files to git immediately
