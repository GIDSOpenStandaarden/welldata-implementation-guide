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

Each observation should be stored in its individual resource with a unique uuid as shown above.

Observations can contain all measured values about a patient. In our project we cover the following observations with the according SNOMED-CT or Loinc codes:

| Name | Description | CODE | Intake vragenlijst | GGDM | Zipster | Selfcare |
| -------- | -------- | -------- | -------- | -------- | -------- | -------- |
| physical_limitation	| aanwezigheid fysieke beperking | 32572006 (Snomed) | x |  | x |  |
| length | Lengte (cm) | 50373000 (Snomed) | x | x |  | x |
| weight | Gewicht (kg) | 27113001 (Snomed) | x | x |  | x |
| Waist_circumference | Buikomtrek  (cm) | 276361009 (Snomed) |  | x |  | x |
| SBP | Systolische bloeddruk (mmHg) | 271649006 (Snomed) |  | x |  | x |
| cholesterol_total	| Totaal cholesterol | 77068002 (Snomed) |   | x |  | x |
| cholesterol_hdl | HDL cholesterol | 02737005 (Snomed) |  | x |  | x |
| cholesterol_ratio	| Totaal / HDL cholesterol | 313811003 (Snomed) |  | x |  | x |
| stress | Stress ervaring | 68011-6 (Loinc) | x | | x | |
| daily_life | Dagelijks leven | 91621-3 (Loinc) | x | |  |  |
| social_contact | Voldoening uit sociale contacten | 61581-5 (Loinc) | x | | x |  |
| physical_exercise | beweegminuten | 228450008 (Snomed) | x | x | | x |
| smoking | roken (ja/nee) | 63638-1	(Loinc) & 77176002 (Snomed) | x | x | | |
| smoking_cigarettes | Hoeveel sigaretten per dag roken | 63640-7	(Loinc) | x | x | | |
| alcohol | Alcohol drinken | 897148007 (Snomed)	| x | x | | |
| alcohol_Frequency | How often do you have a drink containing alcohol | 68518-0	(Loinc) | x | x | | |
| alcohol_normalConsumption | How many standard drinks containing alcohol do you have on a typical day? | 68519-8	(Loinc) | x | x | | |
| alcohol_excessiveConsumption | How often do you have 6 or more drinks on 1 occasion? | 68520-6 (Loinc) | x | x | | |
| birthdate | geboortedatum (dd/mm/yyyy) | 184099003 (Snomed) | x | x | x | |
| postcode | postcode | 184099003 (Snomed) | x | x | x | |
| work | werksituatie | / | x | | x | |
| sex | geslacht | 184100006 (Snomed) | | x | | x |

More information can be found in the sharepoint excel: [Appendix 3. Alignering basis-set met parameters in project applicaties](https://vitoresearch.sharepoint.com/:x:/r/sites/21309-mydata4ourhealth2/Shared%20Documents/General/01%20Werkpakketten/WP3/A.3.1/Deliverables%2031-05-2025/Appendix%203.%20Alignering%20basis-set%20met%20parameters%20in%20project%20applicaties.xlsx?d=w12efbd9a8b924a709fa4dca1e92a1b84&csf=1&web=1&e=gslaTs)

An example of an observation using a quantity type value can be find below.
Please find other kinds of observations here: [Artifacts Summary - WellData Implementation Guide v0.1.1](https://gidsopenstandaarden.github.io/welldata-implementation-guide/artifacts.html).

```
# Use your pod root below.
@base <https://storage.sandbox-pod.datanutsbedrijf.be/a96561f7-3b6a-4631-9e6e-ad19f47e0f81/weare/http%3A%2F%2Fhl7.org%2Ffhir%2FObservation/84cc49e7-b022-4c6c-8122-f7d14e2bc658> .
@prefix pod-patient-folder: <https://storage.sandbox-pod.datanutsbedrijf.be/a96561f7-3b6a-4631-9e6e-ad19f47e0f81/weare/http%3A%2F%2Fhl7.org%2Ffhir%2FPatient/> .
@prefix pod-questionnaire-response-folder: <https://storage.sandbox-pod.datanutsbedrijf.be/a96561f7-3b6a-4631-9e6e-ad19f47e0f81/weare/http%3A%2F%2Fhl7.org%2Ffhir%2FQuestionnaireResponse/> .
@prefix fhir: <http://hl7.org/fhir/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .


<> a fhir:Observation ;
    fhir:text [ fhir:v "Observatie - Total Cholesterol" ] ;
    fhir:issued [
      a fhir:instant ; # Data type here is optional
      fhir:v "2025-10-14T08:28:56.623Z"^^xsd:dateTime
    ] ;
    fhir:status [ fhir:v "final"] ; # Optional, possible values:
                                    # registered | specimen-in-process |
                                    # preliminary | final | amended |
                                    # corrected | appended | cancelled |
                                    # entered-in-error | unknown |
                                    # cannot-be-obtained
    fhir:effective [ # Optional, in case we know when the measurement was made.
       a fhir:dateTime ;
       fhir:v "2013-04-02T10:30:10+01:00"^^xsd:dateTime
    ] ;
    fhir:code [
        a fhir:CodeableConcept ; # Data type here is optional
        fhir:coding ( [
          a fhir:Coding ; # Data type here is optional
          fhir:system [ fhir:v "http://snomed.info/sct" ] ;
          fhir:code [ fhir:v "77068002" ] ;
          fhir:display [ fhir:v "Total Cholesterol" ]
        ] )
    ] ;
    fhir:category ( [
      fhir:text   [ fhir:v "Vragenlijst" ] ;
      fhir:coding ( [
        a fhir:Coding ; # Data type here is optional
        fhir:code   [ fhir:v "survey"^^xsd:string ] ;
        fhir:system [ fhir:v "http://terminology.hl7.org/CodeSystem/observation-category"^^xsd:anyURI ]
      ] )
    ] ) ;
    fhir:subject [
      fhir:link pod-patient-folder:2917eab8-bf6a-416d-8890-0fb0f22b15c0 ;
      fhir:reference [ fhir:v "Patient/2917eab8-bf6a-416d-8890-0fb0f22b15c0"^^xsd:string ] ;
      fhir:type      [ fhir:v "Patient"^^xsd:anyURI ]
    ] ;
    fhir:performer ( [
      fhir:link pod-patient-folder:2917eab8-bf6a-416d-8890-0fb0f22b15c0 ;
      fhir:reference [ fhir:v "Patient/2917eab8-bf6a-416d-8890-0fb0f22b15c0"^^xsd:string ] ;
      fhir:type      [ fhir:v "Patient"^^xsd:anyURI ]
    ] ) ;
    fhir:derivedFrom ( [
      fhir:link pod-questionnaire-response-folder:c75cc7d1-7c42-46f4-a425-e40cdaf8dae2 ;
      fhir:reference [ fhir:v "QuestionnaireResponse/c75cc7d1-7c42-46f4-a425-e40cdaf8dae2"^^xsd:string ] ;
      fhir:type      [ fhir:v "QuestionnaireResponse"^^xsd:anyURI ]
    ] ) ;
    # Example Quantity value.
    fhir:value [
        a fhir:Quantity ;
        fhir:value [ fhir:v "190"^^xsd:decimal ] ;
        fhir:unit [ fhir:v "mg/dL" ] # Example unit, unit not mandatory when code from terminology does not require it.
    ] .
    # Value can be of different types, only one value is allowed
    # Example coding value, "A little of time"
    # fhir:value [
    #   a fhir:CodeableConcept ;
    #   fhir:coding ( [
    #     fhir:code    [ fhir:v "91621-3" ] ;
    #     fhir:system  [ fhir:v "https://loinc.org/LA14732-4"^^xsd:anyURI ] ;
    #     fhir:display [ fhir:v "A little of time" ]
    #   ] )
    # ] . # Value can be of different types, only one value is allowed
    # Example dateTime value, e.g. a birthDate.
    # fhir:value [
    #   a fhir:dateTime ;
    #   fhir:v "1990-10-05T08:28:56.623Z"^^xsd:dateTime
    # ] . # Value can be of different types, only one value is allowed
    # Example string value.
    # fhir:value [
    #   a fhir:string ;
    #   fhir:v "Often"^^xsd:string
    # ] . # Value can be of different types, only one value is allowed
```

### QuestionnaireResponse

A resource of the type QuestionnaireResponse is stored as a [FHIR resource](https://www.hl7.org/fhir/questionnaireresponse.html) at the following location in the users's pod:

`<user pod>/weare/https%3A%2F%2Fwww.hl7.org%2Ffhir%2FQuestionnaireResponse/<uuid>.ttl`
