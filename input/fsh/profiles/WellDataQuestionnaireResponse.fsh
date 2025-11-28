Profile: WellDataQuestionnaireResponse
Parent: QuestionnaireResponse
Title: "WellData QuestionnaireResponse Profile"
Description: "QuestionnaireResponse profile used in the WellData project to persist responses to questionnaires for reuse in data vaults."

// ----------------------------------------------------------------------------
// Narrative & Metadata -------------------------------------------------------
// ----------------------------------------------------------------------------
* text MS

* meta MS
* meta.versionId MS
* meta.lastUpdated MS

// ----------------------------------------------------------------------------
// Identification & Source Questionnaire -------------------------------------
// ----------------------------------------------------------------------------
* identifier 1..1 MS       // canonical URL or other stable identifier for the response
* questionnaire 1..1 MS    // canonical reference to the Questionnaire

// ----------------------------------------------------------------------------
// Context --------------------------------------------------------------------
// ----------------------------------------------------------------------------
* subject 0..1 MS
* status 1..1 MS
* authored 0..1 MS

* author 0..1 MS
* author only Reference(Device or Practitioner or PractitionerRole or Patient or RelatedPerson or Organization)
* author MS

* source 0..1 MS
* source only Reference(Patient or Practitioner or PractitionerRole or RelatedPerson)
* source MS

// ----------------------------------------------------------------------------
// Items & Answers ------------------------------------------------------------
// ----------------------------------------------------------------------------
* item 1..* MS
* item.linkId 1..1 MS
* item.answer MS

* item.answer.value[x] only string or Coding or integer or decimal or boolean or date or dateTime or Quantity
* item.answer.valueString MS
* item.answer.valueCoding MS
* item.answer.valueInteger MS
* item.answer.valueDecimal MS
* item.answer.valueBoolean MS
* item.answer.valueDate MS
* item.answer.valueDateTime MS
* item.answer.valueQuantity MS

// ----------------------------------------------------------------------------
// Publication metadata -------------------------------------------------------
// ----------------------------------------------------------------------------
* ^publisher = "WellData Consortium"
* ^purpose = "Captures questionnaire responses within the WellData ecosystem, ensuring required metadata and answer structure for data reuse."
* ^version = "1.0.0"
* ^status = #active