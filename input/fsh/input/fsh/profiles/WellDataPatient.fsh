Profile: WellDataPatient
Parent: Patient
Title: "WellData Patient Profile"
Description: "Patient profile used in the WellData project capturing key demographic and administrative information."

// ----------------------------------------------------------------------------
// Narrative & Metadata -------------------------------------------------------
// ----------------------------------------------------------------------------
* text MS

* meta MS
* meta.versionId MS
* meta.lastUpdated MS

// ----------------------------------------------------------------------------
// Identifiers (sliced) -------------------------------------------------------
// ----------------------------------------------------------------------------
* identifier ^slicing.discriminator[0].type = #value
* identifier ^slicing.discriminator[0].path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.ordered = false

* identifier contains
    wellurl 1..1 MS and
    ssin 0..1 MS and
    bsn 0..1 MS

* identifier[wellurl].system 1..1 MS
* identifier[wellurl].value 1..1 MS

* identifier[ssin] MS
* identifier[ssin].system 1..1
* identifier[ssin].value 1..1
* identifier[ssin].system = "https://www.ehealth.fgov.be/standards/fhir/core/NamingSystem/ssin" (exactly)

* identifier[bsn] MS
* identifier[bsn].system 1..1
* identifier[bsn].value 1..1
* identifier[bsn].system = "http://fhir.nl/fhir/NamingSystem/bsn" (exactly)

// ----------------------------------------------------------------------------
// Demographics ---------------------------------------------------------------
// ----------------------------------------------------------------------------
* name MS
* telecom MS
* gender MS
* birthDate MS

// Address details ------------------------------------------------------------
* address MS
* address.postalCode MS
* address.country MS

// ----------------------------------------------------------------------------
// Language & Care Team -------------------------------------------------------
// ----------------------------------------------------------------------------
* communication MS
* communication.language MS
* communication.language.coding.system 1..1
* communication.language.coding.code 1..1

* generalPractitioner MS

// ----------------------------------------------------------------------------
// Publication metadata -------------------------------------------------------
// ----------------------------------------------------------------------------
* ^publisher = "WellData Consortium"
* ^purpose = "Captures demographic and administrative data elements relevant for the WellData ecosystem."
* ^version = "1.0.0"
* ^status = #active