# Changelog

All notable changes to the WellData FHIR profiles will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2025-12-03

### Changed
- **WellDataObservation**: Extended `value[x]` to support additional data types:
  - `dateTime`, `string`
  - Previously only `CodeableConcept` and `Quantity` were allowed
- **Documentation**: Updated RDF example in dynamic-data.md to show all supported value types

## [0.1.1] - 2025-11-28

### Added
- **WellDataQuestionnaireResponse**: Extended `item.answer.value[x]` to support additional data types:
  - `integer`, `decimal`, `boolean`, `date`, `dateTime`, `Quantity`
  - Previously only `string` and `Coding` were allowed

### Changed
- **Example Observations**: Added `derivedFrom` references linking observations to their source QuestionnaireResponse
- **Example Observations**: Added explicit `id` and `Usage: #example` to all observation instances for proper TTL generation

### Added (Examples)
- New Health Check Questionnaire (`questionnaire-health-check`) covering:
  - Vital signs (weight, height, waist circumference, blood pressure)
  - Laboratory values (cholesterol)
  - Wellbeing (mood, stress, daily life, social contact, physical limitation)
  - Lifestyle (smoking, alcohol - AUDIT-C)
  - Physical activity
- New Health Check QuestionnaireResponse (`questionnaireresponse-health-check`) with values matching example observations

## [0.1.0] - 2025-10-30

### Added
- Initial release of WellData FHIR profiles
- **WellDataPatient**: Patient profile for WellData project
- **WellDataObservation**: Observation profile for health metrics and survey data
- **WellDataQuestionnaire**: Questionnaire profile for data collection
- **WellDataQuestionnaireResponse**: QuestionnaireResponse profile for questionnaire answers
- Example instances for all profiles including:
  - Patient examples (Dutch patient)
  - 20 Observation examples (vital signs, laboratory, survey, social history, activity)
  - Zipster Questionnaire (social determinants of health)
  - Zipster QuestionnaireResponse
