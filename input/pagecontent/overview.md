## Structure of the WellData specification
The main structure of the welldata specification is displayed below:

<img src="welldata-overview.png" alt="Welldata Overview" style="width: 35%; float: none;">

## Topics of this specification
* Identity and Identity Provisioning
  * How do we uniformly indentify users in different countries?
  * Standards involved:
    * OIDC/SOLID-OIDC, Web-ID
* Pod access and consent
  * Standards involved:
    * SOLID / ACM / WeAre specification
* Availability and exchange of (static) FHIR data
  * How do we exchange / make available / publish resources such as quesionnaires?
  * Do we need a terminology service?
  * Standards involved:
    * https://www.hl7.org/fhir/terminology-service.html
    * FHIR R4
* The shared FHIR user data model
  * What is the FHIR data model?
  * How do we structure the FHIR data in the POD?
  * Standards involved:
    * https://www.hl7.org/fhir/terminology-service.html
    * FHIR R4
* Launch / SSO between applications
  * Start applications from the portal
  * Standards involved:
    * HTI + Web-ID
* Audit Logging
  * [Atna](https://wiki.ihe.net/index.php/Audit_Trail_and_Node_Authentication) standaard
  * WeAre & Athumi
    * X-Request-ID
    * X-Correlation-ID
* Sharing research data*

