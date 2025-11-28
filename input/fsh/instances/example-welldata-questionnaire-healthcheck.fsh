// ===========================================================================
// Health Check Questionnaire - Maps to WellData Observations
// ===========================================================================

Instance: questionnaire-health-check
InstanceOf: WellDataQuestionnaire
Usage: #example
Title: "Gezondheidscheck Vragenlijst"
Description: "Health check questionnaire capturing vital signs, lifestyle, and wellbeing data that maps to WellData Observations."
* id = "questionnaire-health-check"
* identifier.system = "https://well-data.example.org/fhir/Questionnaire"
* identifier.value = "health-check-1-0"
* name = "GezondheidsCheckVragenlijst1_0"
* title = "Gezondheidscheck Vragenlijst"
* status = #draft
* date = "2025-06-10"
* publisher = "WellData Consortium"
* subjectType[0] = #Patient

// ===========================================================================
// Section 1: Vital Signs / Body Measurements
// ===========================================================================

* item[0].linkId = "section-vitals"
* item[0].text = "Lichamelijke metingen"
* item[0].type = #group

* item[0].item[0].linkId = "body-weight"
* item[0].item[0].text = "Wat is uw lichaamsgewicht? (in kg)"
* item[0].item[0].type = #decimal
* item[0].item[0].code.system = "http://snomed.info/sct"
* item[0].item[0].code.code = #27113001
* item[0].item[0].code.display = "Body weight"

* item[0].item[1].linkId = "body-height"
* item[0].item[1].text = "Wat is uw lichaamslengte? (in cm)"
* item[0].item[1].type = #decimal
* item[0].item[1].code.system = "http://snomed.info/sct"
* item[0].item[1].code.code = #50373000
* item[0].item[1].code.display = "Body height"

* item[0].item[2].linkId = "waist-circumference"
* item[0].item[2].text = "Wat is uw tailleomvang? (in cm)"
* item[0].item[2].type = #decimal
* item[0].item[2].code.system = "http://snomed.info/sct"
* item[0].item[2].code.code = #276361009
* item[0].item[2].code.display = "Waist circumference"

* item[0].item[3].linkId = "systolic-bp"
* item[0].item[3].text = "Wat is uw bovendruk (systolische bloeddruk)? (in mmHg)"
* item[0].item[3].type = #integer
* item[0].item[3].code.system = "http://snomed.info/sct"
* item[0].item[3].code.code = #271649006
* item[0].item[3].code.display = "Systolic blood pressure"

// ===========================================================================
// Section 2: Laboratory Values
// ===========================================================================

* item[1].linkId = "section-lab"
* item[1].text = "Laboratoriumwaarden"
* item[1].type = #group

* item[1].item[0].linkId = "cholesterol-total"
* item[1].item[0].text = "Wat is uw totaal cholesterolgehalte? (in mg/dL)"
* item[1].item[0].type = #decimal
* item[1].item[0].code.system = "http://snomed.info/sct"
* item[1].item[0].code.code = #77068002
* item[1].item[0].code.display = "Total cholesterol"

* item[1].item[1].linkId = "cholesterol-hdl"
* item[1].item[1].text = "Wat is uw HDL cholesterolgehalte? (in mg/dL)"
* item[1].item[1].type = #decimal
* item[1].item[1].code.system = "http://snomed.info/sct"
* item[1].item[1].code.code = #102737005
* item[1].item[1].code.display = "HDL cholesterol"

// ===========================================================================
// Section 3: Wellbeing
// ===========================================================================

* item[2].linkId = "section-wellbeing"
* item[2].text = "Welzijn"
* item[2].type = #group

* item[2].item[0].linkId = "mood"
* item[2].item[0].text = "Hoe zou u uw stemming omschrijven?"
* item[2].item[0].type = #choice
* item[2].item[0].code.system = "http://loinc.org"
* item[2].item[0].code.code = #72166-2
* item[2].item[0].code.display = "Mood"
* item[2].item[0].answerOption[0].valueCoding.system = "http://snomed.info/sct"
* item[2].item[0].answerOption[0].valueCoding.code = #32504001
* item[2].item[0].answerOption[0].valueCoding.display = "Gelukkig (Happy)"
* item[2].item[0].answerOption[1].valueCoding.system = "http://snomed.info/sct"
* item[2].item[0].answerOption[1].valueCoding.code = #130987000
* item[2].item[0].answerOption[1].valueCoding.display = "Neutraal (Neutral)"
* item[2].item[0].answerOption[2].valueCoding.system = "http://snomed.info/sct"
* item[2].item[0].answerOption[2].valueCoding.code = #366979004
* item[2].item[0].answerOption[2].valueCoding.display = "Verdrietig (Sad)"
* item[2].item[0].answerOption[3].valueCoding.system = "http://snomed.info/sct"
* item[2].item[0].answerOption[3].valueCoding.code = #48694002
* item[2].item[0].answerOption[3].valueCoding.display = "Angstig (Anxious)"

* item[2].item[1].linkId = "stress"
* item[2].item[1].text = "Hoe ervaart u stress?"
* item[2].item[1].type = #choice
* item[2].item[1].code.system = "http://loinc.org"
* item[2].item[1].code.code = #68011-6
* item[2].item[1].code.display = "Stress level"
* item[2].item[1].answerOption[0].valueCoding.system = "http://loinc.org"
* item[2].item[1].answerOption[0].valueCoding.code = #LA6568-5
* item[2].item[1].answerOption[0].valueCoding.display = "Geen (None)"
* item[2].item[1].answerOption[1].valueCoding.system = "http://loinc.org"
* item[2].item[1].answerOption[1].valueCoding.code = #LA6751-7
* item[2].item[1].answerOption[1].valueCoding.display = "Mild (Mild)"
* item[2].item[1].answerOption[2].valueCoding.system = "http://loinc.org"
* item[2].item[1].answerOption[2].valueCoding.code = #LA13909-9
* item[2].item[1].answerOption[2].valueCoding.display = "Matig (Moderate)"
* item[2].item[1].answerOption[3].valueCoding.system = "http://loinc.org"
* item[2].item[1].answerOption[3].valueCoding.code = #LA6752-5
* item[2].item[1].answerOption[3].valueCoding.display = "Ernstig (Severe)"

* item[2].item[2].linkId = "daily-life"
* item[2].item[2].text = "Hoe functioneert u in het dagelijks leven?"
* item[2].item[2].type = #choice
* item[2].item[2].code.system = "http://loinc.org"
* item[2].item[2].code.code = #91621-3
* item[2].item[2].code.display = "Daily life functioning"
* item[2].item[2].answerOption[0].valueCoding.system = "http://loinc.org"
* item[2].item[2].answerOption[0].valueCoding.code = #LA9207-7
* item[2].item[2].answerOption[0].valueCoding.display = "Uitstekend (Excellent)"
* item[2].item[2].answerOption[1].valueCoding.system = "http://loinc.org"
* item[2].item[2].answerOption[1].valueCoding.code = #LA9206-9
* item[2].item[2].answerOption[1].valueCoding.display = "Goed (Good)"
* item[2].item[2].answerOption[2].valueCoding.system = "http://loinc.org"
* item[2].item[2].answerOption[2].valueCoding.code = #LA9205-1
* item[2].item[2].answerOption[2].valueCoding.display = "Matig (Fair)"
* item[2].item[2].answerOption[3].valueCoding.system = "http://loinc.org"
* item[2].item[2].answerOption[3].valueCoding.code = #LA9208-5
* item[2].item[2].answerOption[3].valueCoding.display = "Slecht (Poor)"

* item[2].item[3].linkId = "social-contact"
* item[2].item[3].text = "Hoe tevreden bent u met uw sociale contacten?"
* item[2].item[3].type = #choice
* item[2].item[3].code.system = "http://loinc.org"
* item[2].item[3].code.code = #61581-5
* item[2].item[3].code.display = "Satisfaction with social contacts"
* item[2].item[3].answerOption[0].valueCoding.system = "http://loinc.org"
* item[2].item[3].answerOption[0].valueCoding.code = #LA9207-7
* item[2].item[3].answerOption[0].valueCoding.display = "Uitstekend (Excellent)"
* item[2].item[3].answerOption[1].valueCoding.system = "http://loinc.org"
* item[2].item[3].answerOption[1].valueCoding.code = #LA9206-9
* item[2].item[3].answerOption[1].valueCoding.display = "Goed (Good)"
* item[2].item[3].answerOption[2].valueCoding.system = "http://loinc.org"
* item[2].item[3].answerOption[2].valueCoding.code = #LA9205-1
* item[2].item[3].answerOption[2].valueCoding.display = "Matig (Fair)"
* item[2].item[3].answerOption[3].valueCoding.system = "http://loinc.org"
* item[2].item[3].answerOption[3].valueCoding.code = #LA9208-5
* item[2].item[3].answerOption[3].valueCoding.display = "Slecht (Poor)"

* item[2].item[4].linkId = "physical-limitation"
* item[2].item[4].text = "Heeft u een fysieke beperking?"
* item[2].item[4].type = #choice
* item[2].item[4].code.system = "http://snomed.info/sct"
* item[2].item[4].code.code = #32572006
* item[2].item[4].code.display = "Physical disability"
* item[2].item[4].answerOption[0].valueCoding.system = "http://snomed.info/sct"
* item[2].item[4].answerOption[0].valueCoding.code = #373066001
* item[2].item[4].answerOption[0].valueCoding.display = "Ja (Yes)"
* item[2].item[4].answerOption[1].valueCoding.system = "http://snomed.info/sct"
* item[2].item[4].answerOption[1].valueCoding.code = #373067005
* item[2].item[4].answerOption[1].valueCoding.display = "Nee (No)"

// ===========================================================================
// Section 4: Lifestyle - Smoking
// ===========================================================================

* item[3].linkId = "section-smoking"
* item[3].text = "Roken"
* item[3].type = #group

* item[3].item[0].linkId = "smoking-status"
* item[3].item[0].text = "Rookt u?"
* item[3].item[0].type = #choice
* item[3].item[0].code.system = "http://loinc.org"
* item[3].item[0].code.code = #63638-1
* item[3].item[0].code.display = "Smoking status"
* item[3].item[0].answerOption[0].valueCoding.system = "http://snomed.info/sct"
* item[3].item[0].answerOption[0].valueCoding.code = #77176002
* item[3].item[0].answerOption[0].valueCoding.display = "Roker (Smoker)"
* item[3].item[0].answerOption[1].valueCoding.system = "http://snomed.info/sct"
* item[3].item[0].answerOption[1].valueCoding.code = #8517006
* item[3].item[0].answerOption[1].valueCoding.display = "Ex-roker (Ex-smoker)"
* item[3].item[0].answerOption[2].valueCoding.system = "http://snomed.info/sct"
* item[3].item[0].answerOption[2].valueCoding.code = #266919005
* item[3].item[0].answerOption[2].valueCoding.display = "Nooit gerookt (Never smoked)"

* item[3].item[1].linkId = "cigarettes-per-day"
* item[3].item[1].text = "Hoeveel sigaretten rookt u per dag?"
* item[3].item[1].type = #integer
* item[3].item[1].code.system = "http://loinc.org"
* item[3].item[1].code.code = #63640-7
* item[3].item[1].code.display = "Cigarettes smoked per day"
* item[3].item[1].enableWhen.question = "smoking-status"
* item[3].item[1].enableWhen.operator = #=
* item[3].item[1].enableWhen.answerCoding.system = "http://snomed.info/sct"
* item[3].item[1].enableWhen.answerCoding.code = #77176002

// ===========================================================================
// Section 5: Lifestyle - Alcohol (AUDIT-C)
// ===========================================================================

* item[4].linkId = "section-alcohol"
* item[4].text = "Alcoholgebruik (AUDIT-C)"
* item[4].type = #group

* item[4].item[0].linkId = "alcohol-status"
* item[4].item[0].text = "Drinkt u alcohol?"
* item[4].item[0].type = #choice
* item[4].item[0].code.system = "http://snomed.info/sct"
* item[4].item[0].code.code = #897148007
* item[4].item[0].code.display = "Alcohol drinking behavior"
* item[4].item[0].answerOption[0].valueCoding.system = "http://snomed.info/sct"
* item[4].item[0].answerOption[0].valueCoding.code = #219006
* item[4].item[0].answerOption[0].valueCoding.display = "Huidige drinker (Current drinker)"
* item[4].item[0].answerOption[1].valueCoding.system = "http://snomed.info/sct"
* item[4].item[0].answerOption[1].valueCoding.code = #105542008
* item[4].item[0].answerOption[1].valueCoding.display = "Ex-drinker (Ex-drinker)"
* item[4].item[0].answerOption[2].valueCoding.system = "http://snomed.info/sct"
* item[4].item[0].answerOption[2].valueCoding.code = #105542003
* item[4].item[0].answerOption[2].valueCoding.display = "Drinkt niet (Non-drinker)"

* item[4].item[1].linkId = "alcohol-frequency"
* item[4].item[1].text = "Hoe vaak drinkt u een drankje met alcohol?"
* item[4].item[1].type = #choice
* item[4].item[1].code.system = "http://loinc.org"
* item[4].item[1].code.code = #68518-0
* item[4].item[1].code.display = "How often do you have a drink containing alcohol"
* item[4].item[1].answerOption[0].valueCoding.system = "http://loinc.org"
* item[4].item[1].answerOption[0].valueCoding.code = #LA6270-8
* item[4].item[1].answerOption[0].valueCoding.display = "Nooit (Never)"
* item[4].item[1].answerOption[1].valueCoding.system = "http://loinc.org"
* item[4].item[1].answerOption[1].valueCoding.code = #LA18926-8
* item[4].item[1].answerOption[1].valueCoding.display = "Maandelijks of minder (Monthly or less)"
* item[4].item[1].answerOption[2].valueCoding.system = "http://loinc.org"
* item[4].item[1].answerOption[2].valueCoding.code = #LA18927-6
* item[4].item[1].answerOption[2].valueCoding.display = "2-4 keer per maand (2-4 times a month)"
* item[4].item[1].answerOption[3].valueCoding.system = "http://loinc.org"
* item[4].item[1].answerOption[3].valueCoding.code = #LA18930-0
* item[4].item[1].answerOption[3].valueCoding.display = "2-3 keer per week (2-3 times a week)"
* item[4].item[1].answerOption[4].valueCoding.system = "http://loinc.org"
* item[4].item[1].answerOption[4].valueCoding.code = #LA18929-2
* item[4].item[1].answerOption[4].valueCoding.display = "4 of meer keer per week (4+ times a week)"

* item[4].item[2].linkId = "alcohol-normal-consumption"
* item[4].item[2].text = "Hoeveel glazen alcohol drinkt u op een typische dag?"
* item[4].item[2].type = #choice
* item[4].item[2].code.system = "http://loinc.org"
* item[4].item[2].code.code = #68519-8
* item[4].item[2].code.display = "How many standard drinks containing alcohol do you have on a typical day"
* item[4].item[2].answerOption[0].valueCoding.system = "http://loinc.org"
* item[4].item[2].answerOption[0].valueCoding.code = #LA15694-5
* item[4].item[2].answerOption[0].valueCoding.display = "1 of 2"
* item[4].item[2].answerOption[1].valueCoding.system = "http://loinc.org"
* item[4].item[2].answerOption[1].valueCoding.code = #LA15695-2
* item[4].item[2].answerOption[1].valueCoding.display = "3 of 4"
* item[4].item[2].answerOption[2].valueCoding.system = "http://loinc.org"
* item[4].item[2].answerOption[2].valueCoding.code = #LA15696-0
* item[4].item[2].answerOption[2].valueCoding.display = "5 of 6"
* item[4].item[2].answerOption[3].valueCoding.system = "http://loinc.org"
* item[4].item[2].answerOption[3].valueCoding.code = #LA15697-8
* item[4].item[2].answerOption[3].valueCoding.display = "7 tot 9"
* item[4].item[2].answerOption[4].valueCoding.system = "http://loinc.org"
* item[4].item[2].answerOption[4].valueCoding.code = #LA15698-6
* item[4].item[2].answerOption[4].valueCoding.display = "10 of meer"

* item[4].item[3].linkId = "alcohol-excessive-consumption"
* item[4].item[3].text = "Hoe vaak drinkt u 6 of meer glazen bij één gelegenheid?"
* item[4].item[3].type = #choice
* item[4].item[3].code.system = "http://loinc.org"
* item[4].item[3].code.code = #68520-6
* item[4].item[3].code.display = "How often do you have 6 or more drinks on 1 occasion"
* item[4].item[3].answerOption[0].valueCoding.system = "http://loinc.org"
* item[4].item[3].answerOption[0].valueCoding.code = #LA6270-8
* item[4].item[3].answerOption[0].valueCoding.display = "Nooit (Never)"
* item[4].item[3].answerOption[1].valueCoding.system = "http://loinc.org"
* item[4].item[3].answerOption[1].valueCoding.code = #LA18933-4
* item[4].item[3].answerOption[1].valueCoding.display = "Minder dan maandelijks (Less than monthly)"
* item[4].item[3].answerOption[2].valueCoding.system = "http://loinc.org"
* item[4].item[3].answerOption[2].valueCoding.code = #LA18934-2
* item[4].item[3].answerOption[2].valueCoding.display = "Maandelijks (Monthly)"
* item[4].item[3].answerOption[3].valueCoding.system = "http://loinc.org"
* item[4].item[3].answerOption[3].valueCoding.code = #LA18935-9
* item[4].item[3].answerOption[3].valueCoding.display = "Wekelijks (Weekly)"
* item[4].item[3].answerOption[4].valueCoding.system = "http://loinc.org"
* item[4].item[3].answerOption[4].valueCoding.code = #LA18936-7
* item[4].item[3].answerOption[4].valueCoding.display = "Dagelijks of bijna dagelijks (Daily or almost daily)"

// ===========================================================================
// Section 6: Physical Activity
// ===========================================================================

* item[5].linkId = "section-activity"
* item[5].text = "Lichamelijke activiteit"
* item[5].type = #group

* item[5].item[0].linkId = "physical-exercise"
* item[5].item[0].text = "Hoeveel minuten per week sport of beweegt u matig tot intensief?"
* item[5].item[0].type = #integer
* item[5].item[0].code.system = "http://snomed.info/sct"
* item[5].item[0].code.code = #228450008
* item[5].item[0].code.display = "Physical activity"
