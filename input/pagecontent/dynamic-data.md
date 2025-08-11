### Pod Organization
Data that is stored in Solid pods is organized in containers and resources. Access can be granted to containers and resources. But in order to find data back and not to share too much information to an application, we propose an organisation structure of data in the pod as follows. The structure follows the resources definitions from [FHIR](https://www.hl7.org/fhir/resourcelist.html). 

For instance if an application is looking for a specific questionnaireResponse, the application should only be given access to the container where all questionnaireResponses are stored. 

To also include information about the resource in the container that is used to store resources, we propose to include the namespace of the FHIR resource as URL encoded.

All information in Welldata will be placed under the following root container of We Are:

`<user pod>/weare/`


### Patient

Information about the patient that fits in the FHIR resource [patient](https://www.hl7.org/fhir/patient.html) must be stored at the following location:

`<user pod>/weare/https%3A%2F%2Fwww.hl7.org%2Ffhir%2FPatient/<uuid>.ttl`

Information that will be stored in the resource:
- Gender
- BirthDate
- Address as a [FHIR datatype](https://build.fhir.org/datatypes.html#Address)
- Language as codeable concept in communication
- Email 
- Tel

### Observation
Observations are stored in the pod at the following location as a [FHIR resource](https://www.hl7.org/fhir/observation.html)

`<user pod>/weare/https%3A%2F%2Fwww.hl7.org%2Ffhir%2FObservation/<uuid>.ttl`

Observations can contain all measured values about a patient. In our project we cover the following observations with the according SNOMED-CT codes:

| Name | Description | SNOMED-CT | Intake vragenlijst | GGDM | Zipster | Selfcare |
| -------- | -------- | -------- | -------- | -------- | -------- | -------- |
| cholesterol_ratio	| Totaal / HDL cholesterol | 313811003 | | x | | x |
| cholesterol_total	| Totaal cholesterol | 77068002 | G
| cholesterol_hdl | HDL cholesterol | 02737005 |
| length | Lengte (cm) | 50373000 |
| weight | Gewicht (kg) | 27113001 |
| BMI | BMI | 60621009 |
| WaistCircumference | Buikomtrek  (cm) | 276361009 |
| SBP | Systolische bloeddruk (mmHg) | 271649006 |

An example of each observation can be found below:

```
@prefix fhir: <http://hl7.org/fhir/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
 
# Cholesterol Ratio
_:obs_chol_ratio a fhir:Observation ;
    fhir:code [
        fhir:system [ fhir:v "http://snomed.info/sct" ] ;
        fhir:code [ fhir:v "313811003" ] ;
        fhir:display [ fhir:v "Cholesterol/HDL ratio" ]
    ] ;
    fhir:valueQuantity [
        fhir:value [ fhir:v "4.5"^^xsd:decimal ]
        ] .
 
# Total Cholesterol
_:obs_chol_total a fhir:Observation ;
    fhir:code [
        fhir:system [ fhir:v "http://snomed.info/sct" ] ;
        fhir:code [ fhir:v "77068002" ] ;
        fhir:display [ fhir:v "Total Cholesterol" ] ] ;
    fhir:valueQuantity [
        fhir:value [ fhir:v "190"^^xsd:decimal ] ;
        fhir:unit [ fhir:v "mg/dL" ]
    ] .
 
# HDL Cholesterol
_:obs_chol_hdl a fhir:Observation ;
    fhir:code [
        fhir:system [ fhir:v "http://snomed.info/sct" ] ;
        fhir:code [ fhir:v "102737005" ] ;
        fhir:display [ fhir:v "HDL Cholesterol" ]
    ] ;
    fhir:valueQuantity [
        fhir:value [ fhir:v "50"^^xsd:decimal ] ;
        fhir:unit [ fhir:v "mg/dL" ]
    ] .
 
# Length (Height)
_:obs_length a fhir:Observation ;
    fhir:code [
        fhir:system [ fhir:v "http://snomed.info/sct" ] ;
        fhir:code [ fhir:v "50373000" ] ;
        fhir:display [ fhir:v "Body height" ]
    ] ;
    fhir:valueQuantity [
        fhir:value [ fhir:v "175"^^xsd:decimal ] ;
        fhir:unit [ fhir:v "cm" ]
    ] .
 
# Weight
_:obs_weight a fhir:Observation ;
    fhir:code [
        fhir:system [ fhir:v "http://snomed.info/sct" ] ;
        fhir:code [ fhir:v "27113001" ] ;
        fhir:display [ fhir:v "Body weight" ]
    ] ;
    fhir:valueQuantity [
        fhir:value [ fhir:v "70"^^xsd:decimal ] ;
        fhir:unit [ fhir:v "kg" ]
    ] .
 
# BMI
_:obs_bmi a fhir:Observation ;
    fhir:code [
        fhir:system [ fhir:v "http://snomed.info/sct" ] ;
        fhir:code [ fhir:v "60621009" ] ;
        fhir:display [ fhir:v "Body Mass Index (BMI)" ]
    ] ;
    fhir:valueQuantity [
        fhir:value [ fhir:v "22.9"^^xsd:decimal ] ;
        fhir:unit [ fhir:v "kg/m²" ]
    ] .
 
# Waist Circumference
_:obs_waist a fhir:Observation ;
    fhir:code [
        fhir:system [ fhir:v "http://snomed.info/sct" ] ;
        fhir:code [ fhir:v "276361009" ] ;
        fhir:display [ fhir:v "Waist Circumference" ]
    ] ;
    fhir:valueQuantity [
        fhir:value [ fhir:v "85"^^xsd:decimal ] ;
        fhir:unit [ fhir:v "cm" ]
    ] .
 
# Systolic Blood Pressure (SBP)
_:obs_sbp a fhir:Observation ;
    fhir:code [
        fhir:system [ fhir:v "http://snomed.info/sct" ] ;
        fhir:code [ fhir:v "271649006" ] ;
        fhir:display [ fhir:v "Systolic blood pressure" ]
    ] ;
    fhir:valueQuantity [
        fhir:value [ fhir:v "120"^^xsd:decimal ] ;
        fhir:unit [ fhir:v "mmHg" ]
    ] .
```

### QuestionnaireResponse

A resource of the type QuestionnaireResponse is stored as a [FHIR resource](https://www.hl7.org/fhir/questionnaireresponse.html) at the following location in the users's pod: 

`<user pod>/weare/https%3A%2F%2Fwww.hl7.org%2Ffhir%2FQuestionnaireResponse/<uuid>.ttl`
