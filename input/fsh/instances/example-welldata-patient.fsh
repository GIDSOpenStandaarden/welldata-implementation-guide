Instance: example-welldata-patient
InstanceOf: WellDataPatient
Title: "Voorbeeld WellData-patiënt"
Description: "Example Patient resource illustrating the recommended data elements for the WellData project."
* meta.versionId = "1"
* meta.lastUpdated = "2025-06-10T08:30:00+02:00"

// --- Narrative -------------------------------------------------------------
* text.status = #generated
* text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>John Doe — voorbeeld patiënt voor WellData</p></div>"

// --- Identifiers -----------------------------------------------------------
* identifier[0].system = "https://well-data.example.org/fhir/Patient"
* identifier[0].value = "example-patient"

* identifier[+].system = "https://www.ehealth.fgov.be/standards/fhir/core/NamingSystem/ssin" // Belgian SSIN ([build.fhir.org](https://build.fhir.org/ig/hl7-be/core/NamingSystem-be-ssin.html?utm_source=chatgpt.com))
* identifier[=].value = "83051812345"

* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/bsn" // Dutch BSN ([ons-api.nl](https://www.ons-api.nl/english/technical/FHIR-ZIBS-GettingStartedWithFhir.html?utm_source=chatgpt.com))
* identifier[=].value = "999991234"

// --- Demographics ----------------------------------------------------------
* name[0].use = #official
* name[0].family = "Doe"
* name[0].given[0] = "John"

* telecom[0].system = #phone
* telecom[0].value = "+32-3-555-0101"
* telecom[0].use = #mobile

* telecom[1].system = #email
* telecom[1].value = "john.doe@example.com"
* telecom[1].use = #home

* gender = #male
* birthDate = "1983-05-18"

* address[0].use = #home
* address[0].line = "Example Street 1"
* address[0].city = "Antwerpen"
* address[0].postalCode = "2000"
* address[0].country = "BE"

// --- Language & Care Team --------------------------------------------------
* communication[0].language.coding.system = "urn:ietf:bcp:47"
* communication[0].language.coding.code = #nl-BE

* generalPractitioner[0].reference = "Practitioner/prac-1"