### Research Data Exchange Overview

The WellData project facilitates the secure and ethical exchange of well-being data for research purposes through a delegated consent model. This approach balances the needs of research with strong user privacy protections and consent management.

```
                          │
                          │
                          │
                          │

     Trusts       ┌─────────────┐        Qualifies
       ┌──────────►Trusted Party│─────────────┐
       │          └─────────────┘             │
       │                                      │
       │                                      │
   ┌──────┐                              ┌────▼─────┐
   │ User │─────► Consent + Data ◄───────│Researcher│
   └──────┘               │              └──────────┘
       │                  │
       │                  │
 ┌─────────────┐     ┌──────────┐
 │ Application │     │Data Store│
 └─────────────┘     └──────────┘

                          │
Private space             │          Anonymous data
                          │
                          │
```


### Key Principles

* **Delegated Consent**: Users delegate authorization decisions to a Trusted Third Party (TTP) rather than directly to individual researchers
* **Preference-Based Consent**: User consent includes specific preferences regarding data usage
* **Data Minimization**: Only necessary data is shared according to consent parameters
* **Qualified Access**: Researchers must meet TTP-defined qualification standards
* **Revocable Consent**: Users maintain the right to revoke consent at any time
* **Trust Network**: Trust relationships are managed through the NUTS network and Verifiable Credentials

### Process Flow

#### 1. Data Collection and Consent Capture
* User completes a questionnaire or task generating well-being data
* User provides consent to the TTP with specific preferences:
  * Research purpose limitations
  * Data type restrictions
  * Time limitations
  * Other user-defined preferences
* Data and consent are stored together in the data store/data station

#### 2. Researcher Qualification
* TTP establishes qualification standards for researchers
* Researchers apply for qualification, providing:
  * Research institution credentials
  * Research purpose documentation
  * Ethics committee approvals (where applicable)
  * Data handling protocols
* TTP evaluates and qualifies researchers according to established criteria

#### 3. Access Permission Management
* Qualified researchers request data access from the TTP
* TTP evaluates whether the request matches user consent preferences
* Upon approval, TTP issues permissions with appropriate limitations
* Permissions are encoded in access tokens or credentials

#### 4. Data Query and Response
* Researchers query the data station with their permissions
* Data station validates:
  * Researcher identity and qualifications
  * Permission validity and scope
  * Matching with stored user consent
* Data is anonymized before release
* All access is logged for audit purposes

#### 5. Consent Management
* Users can view and manage their active consents through the originating application's interface
* Users can modify or revoke consent at any time through the same application that collected the consent
* Consent changes are propagated to affect future data access
* The data store respects consent revocation immediately upon receiving the update

### Trust Management with NUTS

The WellData project leverages the [NUTS network](https://nuts.nl/manifest/) as the foundation for trust management between all participants in the research data ecosystem. NUTS is an open-source trust network that facilitates secure data exchange in healthcare while maintaining user privacy and sovereignty.

#### NUTS Core Principles in WellData

* **Decentralized Trust**: No central authority controls the entire network
* **User Sovereignty**: Users maintain control over their data and consent
* **Cryptographic Verification**: All trust relationships can be cryptographically verified
* **Standardized Protocols**: Ensuring interoperability across the ecosystem

#### Trust Flow Implementation

1. **User to TTP Trust**: Users issue Verifiable Credentials (VCs) to the TTP authorizing them to manage research data access
2. **TTP to Researcher Trust**: TTPs issue VCs to qualified researchers defining their access rights
3. **Data Station to TTP Trust**: Data stations verify the trust chain from researchers through the TTP to user consent
4. **Revocation Management**: All VCs can be revoked through the NUTS network revocation registry

Each participant in the ecosystem maintains a digital wallet that stores their VCs and manages trust relationships according to the NUTS protocols.

### Technical Implementation

#### Consent Storage Format
Consent is stored as a verifiable credential with the following key components:

```
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    "https://nuts.nl/credentials/v1",
    "https://welldata.org/credentials/v1"
  ],
  "type": ["VerifiableCredential", "ResearchConsent"],
  "issuer": "<User-DID>",
  "issuanceDate": "<ISO-8601-timestamp>",
  "expirationDate": "<ISO-8601-timestamp>",
  "credentialSubject": {
    "id": "<TTP-DID>",
    "consentPreferences": {
      "purposeRestrictions": ["medical_research", "public_health", ...],
      "dataTypes": ["questionnaire_responses", "activity_data", ...],
      "minimumAnonymizationLevel": "k-anonymity-5",
      "additionalConditions": [...]
    },
    "dataLocation": "<data-reference-or-container>",
    "nutsRegistryEntry": "<registry-identifier>"
  }
}
```

#### Data Station Requirements
* Secure storage with access controls
* Query processing capabilities with consent validation
* Anonymization techniques (k-anonymity, differential privacy)
* Comprehensive logging and auditing
* User notification mechanisms

#### TTP Qualification Issuance
The TTP issues Verifiable Credentials to qualified researchers through the NUTS network containing:

```
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    "https://nuts.nl/credentials/v1"
  ],
  "type": ["VerifiableCredential", "ResearcherQualification"],
  "issuer": "<TTP-DID>",
  "issuanceDate": "<ISO-8601-timestamp>",
  "expirationDate": "<ISO-8601-timestamp>",
  "credentialSubject": {
    "id": "<Researcher-DID>",
    "qualificationLevel": "<level>",
    "allowedPurposes": ["purpose1", "purpose2", ...],
    "restrictions": {
      "maxQueryFrequency": "<value>",
      "dataRetentionPolicy": "<policy>"
    },
    "evidenceDocuments": ["<reference1>", "<reference2>", ...],
    "nutsRegistryEntry": "<registry-identifier>"
  }
}
```

### Privacy and Security Considerations

#### Anonymization
* Data is anonymized before being shared with researchers
* Techniques include:
  * k-anonymity
  * Differential privacy
  * Data aggregation
  * Removal of identifiers

#### Audit Trail
* All data access is logged with:
  * Researcher identifier
  * Query parameters
  * Timestamp
  * Purpose declaration
  * Data returned (metadata only)

#### Transparency
* Users can view:
  * Active consents
  * Data access logs
  * Research outcomes (where applicable)
  * TTP qualification standards

### Integration with the NUTS Network

For research data, the applications write data and consent directly to the data store, bypassing the SOLID/POD ecosystem. This creates a separate flow specifically optimized for research data management:

#### Direct Data Store Approach
* Research data is written directly to the data store by applications
* Consent is stored alongside the data in the data store
* The data store maintains separation from the healthcare data in SOLID pods
* This approach optimizes for research-specific requirements including anonymization and aggregation

#### NUTS Network Integration
* DIDs (Decentralized Identifiers) and VCs follow NUTS specifications
* Trust relationships are registered and discoverable through the NUTS registry
* Credential exchange happens through NUTS wallets for all participants
* Revocation management uses the NUTS revocation service
* Audit logging can be anchored to the NUTS network for non-repudiation

### Compliance Requirements
* GDPR Article 9 (processing of special category data)
* GDPR Articles 6 & 7 (lawfulness and conditions of consent)
* GDPR Article 89 (research exemptions and safeguards)
* Local research ethics requirements
* Medical research standards where applicable
