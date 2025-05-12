# Technical Walkthrough: Research Data Access in WellData

This document provides a technical walkthrough for accessing research data in the WellData ecosystem using the delegated consent model through a Trusted Third Party (TTP).

## Architecture Overview

In the WellData research data flow, applications write data and consent directly to the data store, bypassing SOLID/POD ecosystem. This creates a separate flow optimized for research data management, including anonymization and aggregation.

## Prerequisites

- NUTS network integration
- DID (Decentralized Identifier) for your organization
- NUTS wallet configured
- Access to data station endpoints

## Step 1: Create a Researcher Subject

### Parameters:
* `baseUrl`, researcher's internal NUTS url: example https://researcher-nuts-node-int.example.com
* `subject`, the subject representing the researcher, for example `researcher-uni-amsterdam`.

```typescript
async function _createResearcherSubject(baseUrl: string, subject: string) {
    let url = `${baseUrl}/internal/vdr/v2/subject`;
    const data = {
        'subject': subject
    }
    let resp = await fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(data)
    })
    if (resp.ok) {
        return await resp.json()
    }
}
```

#### Response value

* A list of did documents. The id field of the DID document is used to register with the TTP.

##### Example

```JSON
{
    "documents": [
        {
            "@context": [
                "https://www.w3.org/ns/did/v1",
                "https://w3c-ccg.github.io/lds-jws2020/contexts/lds-jws2020-v1.json"
            ],
            "assertionMethod": [
                "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456#7f2a9b5c-c3e8-4fd7-9a84-1b6c5d8e9f42"
            ],
            "authentication": [
                "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456#7f2a9b5c-c3e8-4fd7-9a84-1b6c5d8e9f42"
            ],
            "capabilityDelegation": [
                "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456#7f2a9b5c-c3e8-4fd7-9a84-1b6c5d8e9f42"
            ],
            "capabilityInvocation": [
                "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456#7f2a9b5c-c3e8-4fd7-9a84-1b6c5d8e9f42"
            ],
            "id": "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456",
            "verificationMethod": [
                {
                    "controller": "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456",
                    "id": "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456#7f2a9b5c-c3e8-4fd7-9a84-1b6c5d8e9f42",
                    "publicKeyJwk": {
                        "crv": "P-256",
                        "kty": "EC",
                        "x": "MKBCTNIcKUSDii11ySs3526iDZ8AiTo7Tu6KPAqv7D4",
                        "y": "4Etl6SRW2YiLUrN5vfvVHuhp7x8PxltmWWlbbM4IFyM"
                    },
                    "type": "JsonWebKey2020"
                }
            ]
        }
    ],
    "subject": "researcher-uni-amsterdam"
}
```

### Get the DID from the researcher subject
* `baseUrl`, researcher's internal NUTS url: example https://researcher-nuts-node-int.example.com
* `subject`, the subject representing the researcher, for example `researcher-uni-amsterdam`.

```typescript
async function _fetchResearcherDid(baseUrl: string, subject: string) {
    url = `${baseUrl}/internal/vdr/v2/subject/${subject}`
    resp = await fetch(url)
    if (resp.ok) {
        let dids = await resp.json() as Array<string>;
        for (const did of dids) {
            if (did.startsWith('did:web:')) {
                return did
            }
        }
        console.error("Failed to find a did web")
    } else {
        console.error("Failed to get did", resp.statusText)
    }
}
```

#### Response

* The list of did's associated with the researcher account

##### Example
```JSON
[
    "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456"
]
```

### TTP Issues Qualification Credential

**Note**: The actual qualification request process (researcher applying to TTP) happens outside of this technical specification - typically via email, web forms, or other communication channels. Once the TTP approves the researcher, they issue a Verifiable Credential using their NUTS node.

#### Parameters (for TTP issuing the VC):
* `baseUrl`, TTP's internal NUTS url: example https://ttp-nuts-node.example.com
* `researcherDid`, the DID of the researcher being qualified
* `credentialData`, the qualification details for the researcher

```typescript
async function issueResearcherCredential(baseUrl: string, researcherDid: string, credentialData: any) {
    let url = `${baseUrl}/internal/vcr/v2/issuer/vc`;
    const data = {
        "type": "ResearcherQualification",
        "issuer": "did:web:ttp.welldata.example.com",
        "credentialSubject": {
            "id": researcherDid,
            "qualificationLevel": credentialData.level,
            "allowedPurposes": credentialData.purposes,
            "maxKAnonymity": credentialData.anonymityLevel,
            "dataRetentionDays": credentialData.retentionDays
        },
        "expirationDate": credentialData.expirationDate,
        "format": "ldp_vc"
    }
    let resp = await fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(data)
    })
    if (resp.ok) {
        return await resp.json()
    }
}
```

#### Response

* A Verifiable Credential that is then communicated to the researcher through external channels (email, portal, etc.)

##### Example

```JSON
{
    "@context": [
        "https://www.w3.org/2018/credentials/v1",
        "https://nuts.nl/credentials/v1"
    ],
    "type": ["VerifiableCredential", "ResearcherQualification"],
    "issuer": "did:web:ttp.welldata.example.com",
    "issuanceDate": "2024-05-12T10:00:00Z",
    "expirationDate": "2024-12-31T23:59:59Z",
    "credentialSubject": {
        "id": "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456",
        "qualificationLevel": "BasicResearcher",
        "allowedPurposes": ["medical_research", "public_health"],
        "maxKAnonymity": 5,
        "dataRetentionDays": 90
    },
    "proof": {
        "type": "Ed25519Signature2020",
        "created": "2024-05-12T10:00:00Z",
        "verificationMethod": "did:web:ttp.welldata.example.com#key1",
        "proofPurpose": "assertionMethod",
        "proofValue": "z58DAdFfagzSzXdP1..."
    }
}
```

### Store Qualification Credential in NUTS wallet

**Note**: The Verifiable Credential from the previous step is transferred to the researcher through methods outside of this technical specification, such as email, secure portals, or other digital channels. Once the researcher receives the credential, they store it in their NUTS wallet as shown below.

* `baseUrl`, researcher's internal NUTS url: example https://researcher-nuts-node-int.example.com
* `subject`, the subject representing the researcher
* `credential`, the qualification credential from the TTP

```typescript
async function storeQualificationCredential(baseUrl: string, subject: string, credential: any) {
    let url = `${baseUrl}/internal/vcr/v2/holder/${subject}/vc`;
    await fetch(url, {
        method: "POST",
        cache: "no-store",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(credential),
    })
}
```

### Requesting an `access_token`

#### Parameters:

* `baseUrl`, researcher's internal NUTS url: example https://researcher-nuts-node-int.example.com
* `subject`, the subject representing the researcher, for example `researcher-uni-amsterdam`.
* `token_type`, the token type can be either Bearer or DPoP. DPoP is highly preferred and token type Bearer might become deprecated as soon as all parties have implemented DPoP.

#### Return value:

A JSON map with the `access_token` as access token and, in case of token type the field `dpop_kid` is also returned.

```typescript
export async function getAccessToken(baseUrl: string, subject: string) {
    const authorization_server = `https://data-station.welldata.example.com/oauth2/research`
    const url = `${baseUrl}/internal/auth/v2/${subject}/request-service-access-token`;
    const data = {
        "authorization_server": authorization_server,
        "scope": "research_data_read",
        "token_type": 'DPoP' // "Bearer" if skipping DPoP
    }
    return await fetch(url, {
        method: "POST",
        cache: "no-store",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
    }).then((data) => data.json())
}
```

#### Response
* A JSON map with:
  * The `access_token` as access token 
  * The field `dpop_kid` if the `token_type` is DPoP, used for requesting the DPoP header
  * The `expires_in` depicting the validity of the token.
  * The `token_type`, either Bearer of DPoP.

##### Example
```JSON
{
    "access_token": "eyJhbGciOi...X7zPwA",
    "dpop_kid": "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456#7f2a9b5c-c3e8-4fd7-9a84-1b6c5d8e9f42",
    "expires_in": 900,
    "token_type": "DPoP",
    "scope": "research_data_read"
}
```

### Requesting a `DPoP` token

The DPoP header ensures that the same public/private key pair used in requesting the access_token is associated with the key pair used in using the access_token. The access_token can be used for multiple requests as long as it is valid, *a dpop header has to be requested for each individual request*. Each request needs to be signed by the private key, making sure that the access_token cannot be used by anyone other than the owner of the key pair, adding an extra layer of security. The signature method takes as input the URL and request method.

Fortunately, the NUTS node takes care of most of the complexity in getting the DPoP header, the NUTS client just needs to call the NUTS internal endpoint to fetch the DPoP header.

The following example code fetches the header:

#### Parameters:

* `baseUrl`, researcher's internal NUTS url: example https://researcher-nuts-node-int.example.com
* `dpop_kid`: the dpop_kid from the access token response.
* `access_token`: the access_token from the token response.
* `requestMethod`: the HTTP method for the request, for research queries this is `POST`. **Note**: This method must exactly match the method used in the subsequent research data query.
* `requestUrl`: the full URL of the request, for research queries this is `${dataStationUrl}/api/v1/research/query`. **Note**: This URL must exactly match the URL used in the subsequent research data query.

```typescript
export async function getDpopHeader(baseUrl: string, dpop_kid: string, token: string, requestMethod: string, requestUrl: string): Promise<{ dpop: string }> {
    const url = `${baseUrl}/internal/auth/v2/dpop/${encodeURIComponent(dpop_kid)}`;
    const data = {
        "htm": requestMethod,
        "htu": requestUrl,
        "token": token
    }
    return await fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(data)
    })
        .then((data) => data.json() as any)
}
```

#### Return

* A JSON map with the `dpop` as dpop token.

##### Example

```JSON
{
    "dpop": "eyJhbGciOi...Q8mDw"
}
```

### Doing a Research Data Query

The research data query can be done with the access_token as follows:

#### Parameters: 
* `access_token`, the access token as requested above.
* `dpop_header`, the dpop header as requested above.
* `query`, the research query object with consent restrictions.

```typescript
async function queryResearchData(dataStationUrl: string, access_token: string, dpop_header: string, query: any) {
    let url = `${dataStationUrl}/api/v1/research/query`;
    const resp = await fetch(url, {
        method: "POST",
        headers: {
            "Authorization": `DPoP ${access_token}`,
            "DPoP": dpop_header,
            "Content-Type": "application/json",
        },
        body: JSON.stringify(query)
    })
    if (resp.ok) {
        return await resp.json()
    }
}
```

#### Example HTTP Request
```http
POST /api/v1/research/query HTTP/1.1
Authorization: DPoP {access_token}
DPoP: {dpop_header}
Host: data-station.welldata.example.com
Content-Type: application/json

{
    "dataTypes": ["questionnaire_responses"],
    "purposeRestrictions": ["medical_research"],
    "timeRange": {
        "start": "2024-01-01T00:00:00Z",
        "end": "2024-05-01T00:00:00Z"
    },
    "filters": {
        "ageRange": {"min": 18, "max": 65}
    },
    "anonymization": {
        "level": "k-anonymity-5"
    }
}
```

#### Response

* Anonymized research data with consent verification audit logs

##### Example
```JSON
{
    "queryId": "query-789abc-def123",
    "status": "completed",
    "results": {
        "anonymizedData": [
            {
                "id": "anon-123",
                "responses": {
                    "q1": "response_value",
                    "q2": 42
                },
                "demographics": {
                    "ageGroup": "25-34",
                    "region": "anonymized"
                }
            }
        ],
        "metadata": {
            "recordCount": 1247,
            "anonymizationMethod": "k-anonymity-5",
            "queryTimestamp": "2024-05-12T14:30:00Z"
        }
    },
    "auditLog": {
        "researcherDid": "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456",
        "consentMatches": 1247,
        "purposes": ["medical_research"],
        "dataTypes": ["questionnaire_responses"]
    }
}
```

### Verifying Consent Compliance

Consent verification is performed by first doing an introspect call on the access token. This validates the token and returns the consent information associated with it.

#### Parameters:
* `baseUrl`, data station's internal NUTS url: example https://data-station-nuts.example.com
* `access_token`, the access token to introspect

```typescript
export async function introspect(baseUrl: string, access_token: string) {
    const url = `${baseUrl}/internal/auth/v2/accesstoken/introspect_extended`
    return await fetch(url, {
        method: "POST",
        body: 'token=' + encodeURIComponent(access_token),
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    }).then((data) => data.json())
}
```

#### Response

* Token introspection details including consent information and permissions

##### Example
```JSON
{
    "active": true,
    "token_type": "Bearer",
    "scope": "research_data_read",
    "username": "did:web:nuts-node.example.com:iam:8ca9e2b7-d5a8-4b9f-a1c3-e6f8d712b456",
    "exp": 1699876543,
    "iat": 1699875643,
    "jti": "access-token-12345",
    "client_id": "researcher-uni-amsterdam",
    "consent": {
        "purposes": ["medical_research", "public_health"],
        "dataTypes": ["questionnaire_responses"],
        "maxKAnonymity": 5,
        "dataRetentionDays": 90,
        "grantedBy": "did:web:ttp.welldata.example.com",
        "grantedAt": "2024-05-12T10:00:00Z"
    },
    "permissions": {
        "read": ["questionnaire_responses"],
        "anonymizationLevel": "k-anonymity-5",
        "purposeRestrictions": ["medical_research", "public_health"]
    }
}
```

### Validating Query Against Consent

After introspecting the token, validate that your research query complies with the consent permissions:

```typescript
async function validateQueryConsent(access_token: string, query: any, dataStationBaseUrl: string) {
    const introspection = await introspect(dataStationBaseUrl, access_token);
    
    if (!introspection.active) {
        throw new Error("Access token is not active");
    }
    
    // Validate purposes
    const allowedPurposes = introspection.consent.purposes;
    if (!query.purposeRestrictions.every(p => allowedPurposes.includes(p))) {
        throw new Error("Query purposes exceed consent permissions");
    }
    
    // Validate data types
    const allowedDataTypes = introspection.consent.dataTypes;
    if (!query.dataTypes.every(dt => allowedDataTypes.includes(dt))) {
        throw new Error("Query data types exceed consent permissions");
    }
    
    // Validate anonymization level
    if (query.anonymization.level !== `k-anonymity-${introspection.consent.maxKAnonymity}`) {
        throw new Error("Query anonymization level does not match consent requirements");
    }
    
    return true;
}
```

### Validating DPoP Headers

When using DPoP tokens, the DPoP header must also be validated in addition to the access token. The procedure for validating request headers is as follows:

1. Extract the `Authorization` header from the request
2. Determine if it's `Bearer` or `DPoP` using regex: `^(Bearer|DPoP) (.+)$`
3. If `Bearer`, only validate the access token
4. If `DPoP`, validate both the access token and the DPoP header

#### Parameters:
* `baseUrl`, data station's internal NUTS url: example https://data-station-nuts.example.com
* `dpop_header`, the DPoP header from the request
* `access_token`, the access token from the Authorization header
* `cnfJkt`, the thumbprint from the introspection response at the field `cnf.jkt`
* `request_url`, the URL of the request
* `request_method`, the HTTP method from the request (e.g., `GET`, `POST`)

```typescript
export async function validateDpop(
    baseUrl: string, 
    access_token: string, 
    dpop_header: string, 
    cnfJkt: string, 
    request_url: string, 
    request_method: string
) {
    const url = `${baseUrl}/internal/auth/v2/dpop/validate`;
    const data = {
        "dpop_proof": dpop_header,
        "thumbprint": cnfJkt,
        "token": access_token,
        "url": request_url,
        "method": request_method
    };
    return await fetch(url, {
        method: "POST",
        body: JSON.stringify(data),
        headers: {
            'Content-Type': 'application/json'
        }
    }).then((data) => data.json());
}
```

#### Response

* A validation result indicating if the DPoP header is valid

##### Example
```JSON
{
    "valid": true
}
```

#### Complete Authorization Validation Example

Here's how to validate both the access token and DPoP header together:

```typescript
async function validateAuthorizationHeader(
    baseUrl: string, 
    authorizationHeader: string, 
    dpopHeader: string,
    requestUrl: string,
    requestMethod: string
) {
    // Parse authorization header
    const authMatch = authorizationHeader.match(/^(Bearer|DPoP) (.+)$/);
    if (!authMatch) {
        throw new Error("Invalid Authorization header format");
    }
    
    const [, tokenType, accessToken] = authMatch;
    
    // Introspect access token
    const introspection = await introspect(baseUrl, accessToken);
    
    if (!introspection.active) {
        throw new Error("Access token is not active");
    }
    
    // Validate scope, issuer, etc.
    if (introspection.scope !== "research_data_read") {
        throw new Error("Invalid scope for research data access");
    }
    
    // If using DPoP, validate the DPoP header
    if (tokenType === "DPoP") {
        if (!dpopHeader) {
            throw new Error("DPoP header required for DPoP tokens");
        }
        
        if (!introspection.cnf?.jkt) {
            throw new Error("Token confirmation thumbprint missing");
        }
        
        const dpopValidation = await validateDpop(
            baseUrl,
            accessToken,
            dpopHeader,
            introspection.cnf.jkt,
            requestUrl,
            requestMethod
        );
        
        if (!dpopValidation.valid) {
            throw new Error("Invalid DPoP header");
        }
    }
    
    return introspection;
}
```

### Important Validation Checks

When validating the introspection response, ensure:

1. **`active` field**: Must be `true` (note: response status will be 200 even if token is invalid)
2. **`scope` field**: Must match the expected scope for research data access
3. **`iss` field**: Must match the authorization server URL
4. **`client_id` field**: Must match the expected client ID
5. **`cnf.jkt` field**: Must be present for DPoP tokens and used for header validation