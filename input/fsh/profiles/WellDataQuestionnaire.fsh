Profile: WellDataQuestionnaire
Parent: Questionnaire
Title: "WellData Questionnaire Profile"
Description: "Questionnaire resource used in the WellData project to publish structured question sets without responses."

// ----------------------------------------------------------------------------
// Narrative & Metadata -------------------------------------------------------
// ----------------------------------------------------------------------------
* text MS

* meta MS
* meta.versionId MS
* meta.lastUpdated MS

// ----------------------------------------------------------------------------
// Administrative -------------------------------------------------------------
// ----------------------------------------------------------------------------
* identifier 1..1 MS   // canonical URL or other stable identifier
* name 1..1 MS         // computer‑readable name
* title 1..1 MS        // human‑friendly name
* status 1..1 MS       // draft | active | retired | unknown
* date 1..1 MS         // last change date
* publisher 1..1 MS

// ----------------------------------------------------------------------------
// Subject & Usage ------------------------------------------------------------
// ----------------------------------------------------------------------------
* subjectType MS       // types of subjects the questionnaire can be applied to

// ----------------------------------------------------------------------------
// Items (questions / groups) --------------------------------------------------
// ----------------------------------------------------------------------------
* item 1..* MS
* item.linkId 1..1 MS
* item.type 1..1 MS
* item.enableWhen MS
* item.required MS
* item.answerOption MS

* item.answerOption.value[x] only string or Coding
* item.answerOption.valueString MS
* item.answerOption.valueCoding MS

// ----------------------------------------------------------------------------
// Publication metadata -------------------------------------------------------
// ----------------------------------------------------------------------------
* ^publisher = "WellData Consortium"
* ^purpose = "Defines the structure of questionnaires distributed within the WellData ecosystem, ensuring consistent metadata and item definitions."
* ^version = "1.0.0"
* ^status = #active