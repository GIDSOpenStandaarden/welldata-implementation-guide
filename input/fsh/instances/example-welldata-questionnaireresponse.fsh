Instance: questionnaireresponse-zipster
InstanceOf: WellDataQuestionnaireResponse
Usage: #example
Title: "Antwoorden Zipster Vragenlijst 3.0"
Description: "Example QuestionnaireResponse filled in for the Zipster questionnaire (versie 3.0)."
* id = "questionnaireresponse-zipster"
* identifier.system = "https://well-data.example.org/fhir/QuestionnaireResponse"
* identifier.value = "zipster-3-0-response-001"
* questionnaire = "Questionnaire/questionnaire-zipster"
* status = #completed
* subject.reference = "Patient/example-welldata-patient"
* authored = "2025-06-10T10:15:00+02:00"
* author.reference = "Practitioner/prac-1"
* source.reference = "Patient/example-welldata-patient"

// ---------------------------------------------------------------------------
// Section 1
* item[0].linkId = "1.1"
* item[0].answer[0].valueString = "Nee"

* item[1].linkId = "1.2"
* item[1].answer[0].valueString = "Nee"

* item[2].linkId = "1.3"
* item[2].answer[0].valueString = "Ja"

* item[3].linkId = "1.4"
* item[3].answer[0].valueString = "Nee"

* item[4].linkId = "1.5"
* item[4].answer[0].valueString = "Ja"

// ---------------------------------------------------------------------------
// Section 2
* item[5].linkId = "2.1"
* item[5].answer[0].valueString = "Nee"

* item[6].linkId = "2.2"
* item[6].answer[0].valueString = "Ja"

* item[7].linkId = "2.3"
* item[7].answer[0].valueString = "Nee"

* item[8].linkId = "2.4"
* item[8].answer[0].valueString = "Ja"

* item[9].linkId = "2.5"
* item[9].answer[0].valueString = "Nee"

* item[10].linkId = "2.6"
* item[10].answer[0].valueString = "Nee"

* item[11].linkId = "2.7"
* item[11].answer[0].valueString = "Ja"

* item[12].linkId = "2.8"
* item[12].answer[0].valueString = "Nee"

* item[13].linkId = "2.9"
* item[13].answer[0].valueString = "Ja"