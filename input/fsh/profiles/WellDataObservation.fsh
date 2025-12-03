Profile: WellDataObservation
Parent: Observation
Title: "WellData Observation Profile"
Description: "Observation used in the WellData project to record observation from the different apps in the WellData exosystem."

// --- Human‑readable narrative -------------------------------------------------
* text 0..1 MS

// --- Metadata tracking -------------------------------------------------------
* meta 0..1 MS
* meta.versionId 0..1 MS
* meta.lastUpdated 0..1 MS

// --- Identification ----------------------------------------------------------
* identifier 0..* MS

// --- Core Observation fields -------------------------------------------------
* status 1..1 MS
* category 0..* MS

* code 1..1 MS
* code.coding.system 1..1
* code.coding.code 1..1
* code.coding.display MS

* subject 1..1 MS
* issued 0..1 MS
* performer 0..* MS


// --- Provenance --------------------------------------------------------------
* derivedFrom 0..* MS
* derivedFrom only Reference(QuestionnaireResponse)

// --- Timing ------------------------------------------------------------------
* effective[x] only dateTime
* effectiveDateTime 1..1 MS

// --- Value choices -----------------------------------------------------------
* value[x] only CodeableConcept or Quantity or dateTime or string

* valueCodeableConcept 0..1 MS
* valueCodeableConcept.coding.system 1..1
* valueCodeableConcept.coding.code 1..1
* valueCodeableConcept.coding.display MS

* valueQuantity 0..1 MS
* valueQuantity.value 1..1
* valueQuantity.unit 1..1

* valueDateTime 0..1 MS
* valueString 0..1 MS

// --- Metadata for publication ------------------------------------------------
* ^publisher = "WellData Consortium"
* ^purpose = "Captures observations related to support needs expressed as coded concepts or quantitative measurements."
* ^version = "1.0.0"
* ^status = #active