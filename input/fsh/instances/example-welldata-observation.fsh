// ===========================================================================
// Example WellData Observations
// ===========================================================================

// 1. Mood (coded concept)
Instance: example-well-mood
InstanceOf: WellDataObservation
Title: "Voorbeeld Mood Observation"
Description: "Example observation capturing a patient's mood as a coded concept."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #survey
* code.coding.system = "http://loinc.org"
* code.coding.code = #72166-2
* code.coding.display = "Mood"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:00:00+02:00"
* valueCodeableConcept.coding.system = "http://snomed.info/sct"
* valueCodeableConcept.coding.code = #32504001
* valueCodeableConcept.coding.display = "Happy"

// ---------------------------------------------------------------------------
// 2. Cholesterol/HDL Ratio
Instance: example-cholesterol-ratio
InstanceOf: WellDataObservation
Title: "Cholesterol/HDL Ratio"
Description: "Cholesterol to HDL ratio."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #laboratory
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #313811003
* code.coding.display = "Cholesterol/HDL ratio"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T08:50:00+02:00"
* valueQuantity.value = 4.5
* valueQuantity.unit = "ratio"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #ratio

// ---------------------------------------------------------------------------
// 3. Total Cholesterol
Instance: example-cholesterol-total
InstanceOf: WellDataObservation
Title: "Total Cholesterol"
Description: "Total cholesterol measurement."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #laboratory
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #77068002
* code.coding.display = "Total Cholesterol"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T08:52:00+02:00"
* valueQuantity.value = 190
* valueQuantity.unit = "mg/dL"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #mg/dL

// ---------------------------------------------------------------------------
// 4. HDL Cholesterol
Instance: example-cholesterol-hdl
InstanceOf: WellDataObservation
Title: "HDL Cholesterol"
Description: "High-density lipoprotein (HDL) cholesterol measurement."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #laboratory
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #102737005
* code.coding.display = "HDL Cholesterol"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T08:53:00+02:00"
* valueQuantity.value = 50
* valueQuantity.unit = "mg/dL"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #mg/dL

// ---------------------------------------------------------------------------
// 5. Body Height
Instance: example-body-height
InstanceOf: WellDataObservation
Title: "Body Height"
Description: "Body height measurement."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #vital-signs
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #50373000
* code.coding.display = "Body height"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T08:54:00+02:00"
* valueQuantity.value = 175
* valueQuantity.unit = "cm"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #cm

// ---------------------------------------------------------------------------
// 6. Body Weight
Instance: example-body-weight
InstanceOf: WellDataObservation
Title: "Body Weight"
Description: "Body weight measurement."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #vital-signs
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #27113001
* code.coding.display = "Body weight"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T08:55:00+02:00"
* valueQuantity.value = 70
* valueQuantity.unit = "kg"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #kg

// ---------------------------------------------------------------------------
// 7. Body Mass Index (BMI)
Instance: example-bmi
InstanceOf: WellDataObservation
Title: "Body Mass Index"
Description: "BMI derived from height and weight."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #vital-signs
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #60621009
* code.coding.display = "Body Mass Index (BMI)"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T08:56:00+02:00"
* valueQuantity.value = 22.9
* valueQuantity.unit = "kg/m2"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #kg/m2

// ---------------------------------------------------------------------------
// 8. Waist Circumference
Instance: example-waist-circumference
InstanceOf: WellDataObservation
Title: "Waist Circumference"
Description: "Waist circumference measurement."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #vital-signs
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #276361009
* code.coding.display = "Waist Circumference"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T08:57:00+02:00"
* valueQuantity.value = 85
* valueQuantity.unit = "cm"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #cm

// ---------------------------------------------------------------------------
// 9. Systolic Blood Pressure
Instance: example-systolic-bp
InstanceOf: WellDataObservation
Title: "Systolic Blood Pressure"
Description: "Systolic blood pressure measurement."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #vital-signs
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #271649006
* code.coding.display = "Systolic blood pressure"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T08:58:00+02:00"
* valueQuantity.value = 120
* valueQuantity.unit = "mmHg"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #mm[Hg]

// ---------------------------------------------------------------------------
// 10. Physical Limitation (coded yes/no)
Instance: example-physical-limitation
InstanceOf: WellDataObservation
Title: "Physical Limitation"
Description: "Presence of physical limitation (aanwezigheid fysieke beperking)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #survey
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #32572006
* code.coding.display = "Physical disability"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:00:00+02:00"
* valueCodeableConcept.coding.system = "http://snomed.info/sct"
* valueCodeableConcept.coding.code = #373066001
* valueCodeableConcept.coding.display = "Yes"

// ---------------------------------------------------------------------------
// 11. Stress Experience
Instance: example-stress
InstanceOf: WellDataObservation
Title: "Stress Experience"
Description: "Stress experience level (stress ervaring)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #survey
* code.coding.system = "http://loinc.org"
* code.coding.code = #68011-6
* code.coding.display = "Stress level"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:01:00+02:00"
* valueCodeableConcept.coding.system = "http://loinc.org"
* valueCodeableConcept.coding.code = #LA13909-9
* valueCodeableConcept.coding.display = "Moderate"

// ---------------------------------------------------------------------------
// 12. Daily Life Functioning
Instance: example-daily-life
InstanceOf: WellDataObservation
Title: "Daily Life Functioning"
Description: "Daily life functioning assessment (dagelijks leven)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #survey
* code.coding.system = "http://loinc.org"
* code.coding.code = #91621-3
* code.coding.display = "Daily life functioning"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:02:00+02:00"
* valueCodeableConcept.coding.system = "http://loinc.org"
* valueCodeableConcept.coding.code = #LA9206-9
* valueCodeableConcept.coding.display = "Good"

// ---------------------------------------------------------------------------
// 13. Social Contact Satisfaction
Instance: example-social-contact
InstanceOf: WellDataObservation
Title: "Social Contact Satisfaction"
Description: "Satisfaction with social contacts (voldoening uit sociale contacten)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #survey
* code.coding.system = "http://loinc.org"
* code.coding.code = #61581-5
* code.coding.display = "Satisfaction with social contacts"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:03:00+02:00"
* valueCodeableConcept.coding.system = "http://loinc.org"
* valueCodeableConcept.coding.code = #LA9206-9
* valueCodeableConcept.coding.display = "Good"

// ---------------------------------------------------------------------------
// 14. Physical Exercise (minutes)
Instance: example-physical-exercise
InstanceOf: WellDataObservation
Title: "Physical Exercise Minutes"
Description: "Physical exercise in minutes per week (beweegminuten)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #activity
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #228450008
* code.coding.display = "Physical activity"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:04:00+02:00"
* valueQuantity.value = 150
* valueQuantity.unit = "min/wk"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #min/wk

// ---------------------------------------------------------------------------
// 15. Smoking Status
Instance: example-smoking-status
InstanceOf: WellDataObservation
Title: "Smoking Status"
Description: "Smoking status (roken ja/nee)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #social-history
* code.coding.system = "http://loinc.org"
* code.coding.code = #63638-1
* code.coding.display = "Smoking status"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:05:00+02:00"
* valueCodeableConcept.coding.system = "http://snomed.info/sct"
* valueCodeableConcept.coding.code = #77176002
* valueCodeableConcept.coding.display = "Smoker"

// ---------------------------------------------------------------------------
// 16. Cigarettes Per Day
Instance: example-cigarettes-per-day
InstanceOf: WellDataObservation
Title: "Cigarettes Per Day"
Description: "Number of cigarettes smoked per day (sigaretten per dag)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #social-history
* code.coding.system = "http://loinc.org"
* code.coding.code = #63640-7
* code.coding.display = "Cigarettes smoked per day"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:06:00+02:00"
* valueQuantity.value = 10
* valueQuantity.unit = "/d"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #/d

// ---------------------------------------------------------------------------
// 17. Alcohol Use Status
Instance: example-alcohol-status
InstanceOf: WellDataObservation
Title: "Alcohol Use Status"
Description: "Alcohol use status (alcohol drinken)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #social-history
* code.coding.system = "http://snomed.info/sct"
* code.coding.code = #897148007
* code.coding.display = "Alcohol drinking behavior"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:07:00+02:00"
* valueCodeableConcept.coding.system = "http://snomed.info/sct"
* valueCodeableConcept.coding.code = #219006
* valueCodeableConcept.coding.display = "Current drinker"

// ---------------------------------------------------------------------------
// 18. Alcohol Frequency (AUDIT-C Q1)
Instance: example-alcohol-frequency
InstanceOf: WellDataObservation
Title: "Alcohol Frequency"
Description: "How often do you have a drink containing alcohol (AUDIT-C Q1)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #social-history
* code.coding.system = "http://loinc.org"
* code.coding.code = #68518-0
* code.coding.display = "How often do you have a drink containing alcohol"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:08:00+02:00"
* valueCodeableConcept.coding.system = "http://loinc.org"
* valueCodeableConcept.coding.code = #LA18930-0
* valueCodeableConcept.coding.display = "2-3 times a week"

// ---------------------------------------------------------------------------
// 19. Alcohol Normal Consumption (AUDIT-C Q2)
Instance: example-alcohol-normal-consumption
InstanceOf: WellDataObservation
Title: "Alcohol Normal Consumption"
Description: "How many standard drinks on a typical day (AUDIT-C Q2)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #social-history
* code.coding.system = "http://loinc.org"
* code.coding.code = #68519-8
* code.coding.display = "How many standard drinks containing alcohol do you have on a typical day"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:09:00+02:00"
* valueCodeableConcept.coding.system = "http://loinc.org"
* valueCodeableConcept.coding.code = #LA15694-5
* valueCodeableConcept.coding.display = "1 or 2"

// ---------------------------------------------------------------------------
// 20. Alcohol Excessive Consumption (AUDIT-C Q3)
Instance: example-alcohol-excessive-consumption
InstanceOf: WellDataObservation
Title: "Alcohol Excessive Consumption"
Description: "How often do you have 6 or more drinks on one occasion (AUDIT-C Q3)."
* status = #final
* category[0].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category"
* category[0].coding.code = #social-history
* code.coding.system = "http://loinc.org"
* code.coding.code = #68520-6
* code.coding.display = "How often do you have 6 or more drinks on 1 occasion"
* subject.reference = "Patient/example-welldata-patient"
* effectiveDateTime = "2025-06-10T09:10:00+02:00"
* valueCodeableConcept.coding.system = "http://loinc.org"
* valueCodeableConcept.coding.code = #LA18933-4
* valueCodeableConcept.coding.display = "Less than monthly"