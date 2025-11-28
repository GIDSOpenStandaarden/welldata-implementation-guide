// ===========================================================================
// Health Check QuestionnaireResponse - Maps to WellData Observations
// ===========================================================================

Instance: questionnaireresponse-health-check
InstanceOf: WellDataQuestionnaireResponse
Usage: #example
Title: "Gezondheidscheck Vragenlijst Antwoorden"
Description: "Completed health check questionnaire with answers matching the example WellData Observations."
* id = "questionnaireresponse-health-check"
* identifier.system = "https://well-data.example.org/fhir/QuestionnaireResponse"
* identifier.value = "health-check-1-0-response-001"
* questionnaire = "Questionnaire/questionnaire-health-check"
* status = #completed
* subject.reference = "Patient/example-welldata-patient"
* authored = "2025-06-10T09:15:00+02:00"
* author.reference = "Patient/example-welldata-patient"

// ===========================================================================
// Section 1: Vital Signs / Body Measurements
// ===========================================================================

* item[0].linkId = "section-vitals"
* item[0].text = "Lichamelijke metingen"

* item[0].item[0].linkId = "body-weight"
* item[0].item[0].text = "Wat is uw lichaamsgewicht? (in kg)"
* item[0].item[0].answer.valueDecimal = 70

* item[0].item[1].linkId = "body-height"
* item[0].item[1].text = "Wat is uw lichaamslengte? (in cm)"
* item[0].item[1].answer.valueDecimal = 175

* item[0].item[2].linkId = "waist-circumference"
* item[0].item[2].text = "Wat is uw tailleomvang? (in cm)"
* item[0].item[2].answer.valueDecimal = 85

* item[0].item[3].linkId = "systolic-bp"
* item[0].item[3].text = "Wat is uw bovendruk (systolische bloeddruk)? (in mmHg)"
* item[0].item[3].answer.valueInteger = 120

// ===========================================================================
// Section 2: Laboratory Values
// ===========================================================================

* item[1].linkId = "section-lab"
* item[1].text = "Laboratoriumwaarden"

* item[1].item[0].linkId = "cholesterol-total"
* item[1].item[0].text = "Wat is uw totaal cholesterolgehalte? (in mg/dL)"
* item[1].item[0].answer.valueDecimal = 190

* item[1].item[1].linkId = "cholesterol-hdl"
* item[1].item[1].text = "Wat is uw HDL cholesterolgehalte? (in mg/dL)"
* item[1].item[1].answer.valueDecimal = 50

// ===========================================================================
// Section 3: Wellbeing
// ===========================================================================

* item[2].linkId = "section-wellbeing"
* item[2].text = "Welzijn"

* item[2].item[0].linkId = "mood"
* item[2].item[0].text = "Hoe zou u uw stemming omschrijven?"
* item[2].item[0].answer.valueCoding.system = "http://snomed.info/sct"
* item[2].item[0].answer.valueCoding.code = #32504001
* item[2].item[0].answer.valueCoding.display = "Gelukkig (Happy)"

* item[2].item[1].linkId = "stress"
* item[2].item[1].text = "Hoe ervaart u stress?"
* item[2].item[1].answer.valueCoding.system = "http://loinc.org"
* item[2].item[1].answer.valueCoding.code = #LA13909-9
* item[2].item[1].answer.valueCoding.display = "Matig (Moderate)"

* item[2].item[2].linkId = "daily-life"
* item[2].item[2].text = "Hoe functioneert u in het dagelijks leven?"
* item[2].item[2].answer.valueCoding.system = "http://loinc.org"
* item[2].item[2].answer.valueCoding.code = #LA9206-9
* item[2].item[2].answer.valueCoding.display = "Goed (Good)"

* item[2].item[3].linkId = "social-contact"
* item[2].item[3].text = "Hoe tevreden bent u met uw sociale contacten?"
* item[2].item[3].answer.valueCoding.system = "http://loinc.org"
* item[2].item[3].answer.valueCoding.code = #LA9206-9
* item[2].item[3].answer.valueCoding.display = "Goed (Good)"

* item[2].item[4].linkId = "physical-limitation"
* item[2].item[4].text = "Heeft u een fysieke beperking?"
* item[2].item[4].answer.valueCoding.system = "http://snomed.info/sct"
* item[2].item[4].answer.valueCoding.code = #373066001
* item[2].item[4].answer.valueCoding.display = "Ja (Yes)"

// ===========================================================================
// Section 4: Lifestyle - Smoking
// ===========================================================================

* item[3].linkId = "section-smoking"
* item[3].text = "Roken"

* item[3].item[0].linkId = "smoking-status"
* item[3].item[0].text = "Rookt u?"
* item[3].item[0].answer.valueCoding.system = "http://snomed.info/sct"
* item[3].item[0].answer.valueCoding.code = #77176002
* item[3].item[0].answer.valueCoding.display = "Roker (Smoker)"

* item[3].item[1].linkId = "cigarettes-per-day"
* item[3].item[1].text = "Hoeveel sigaretten rookt u per dag?"
* item[3].item[1].answer.valueInteger = 10

// ===========================================================================
// Section 5: Lifestyle - Alcohol (AUDIT-C)
// ===========================================================================

* item[4].linkId = "section-alcohol"
* item[4].text = "Alcoholgebruik (AUDIT-C)"

* item[4].item[0].linkId = "alcohol-status"
* item[4].item[0].text = "Drinkt u alcohol?"
* item[4].item[0].answer.valueCoding.system = "http://snomed.info/sct"
* item[4].item[0].answer.valueCoding.code = #219006
* item[4].item[0].answer.valueCoding.display = "Huidige drinker (Current drinker)"

* item[4].item[1].linkId = "alcohol-frequency"
* item[4].item[1].text = "Hoe vaak drinkt u een drankje met alcohol?"
* item[4].item[1].answer.valueCoding.system = "http://loinc.org"
* item[4].item[1].answer.valueCoding.code = #LA18930-0
* item[4].item[1].answer.valueCoding.display = "2-3 keer per week (2-3 times a week)"

* item[4].item[2].linkId = "alcohol-normal-consumption"
* item[4].item[2].text = "Hoeveel glazen alcohol drinkt u op een typische dag?"
* item[4].item[2].answer.valueCoding.system = "http://loinc.org"
* item[4].item[2].answer.valueCoding.code = #LA15694-5
* item[4].item[2].answer.valueCoding.display = "1 of 2"

* item[4].item[3].linkId = "alcohol-excessive-consumption"
* item[4].item[3].text = "Hoe vaak drinkt u 6 of meer glazen bij één gelegenheid?"
* item[4].item[3].answer.valueCoding.system = "http://loinc.org"
* item[4].item[3].answer.valueCoding.code = #LA18933-4
* item[4].item[3].answer.valueCoding.display = "Minder dan maandelijks (Less than monthly)"

// ===========================================================================
// Section 6: Physical Activity
// ===========================================================================

* item[5].linkId = "section-activity"
* item[5].text = "Lichamelijke activiteit"

* item[5].item[0].linkId = "physical-exercise"
* item[5].item[0].text = "Hoeveel minuten per week sport of beweegt u matig tot intensief?"
* item[5].item[0].answer.valueInteger = 150
