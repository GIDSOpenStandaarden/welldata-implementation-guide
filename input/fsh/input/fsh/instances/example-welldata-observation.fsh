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