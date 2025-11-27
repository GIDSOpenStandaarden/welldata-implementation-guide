### Ephemeral FHIR Service

This document describes the technical architecture for an ephemeral FHIR service that provides a full FHIR R4 API backed by data stored in a Solid pod. The service acts as a translation and query layer between FHIR clients and the user's personal data store.

#### Problem Statement

FHIR is designed as an exchange format optimized for interoperability between healthcare systems. It allows multiple valid representations of the same data and relies heavily on server-side search and query capabilities. Solid pods, on the other hand, are personal data stores that:

- Store data as RDF (Linked Data)
- Have limited query capabilities (LDP, no full SPARQL by default)
- Require a canonical data representation
- Are designed for user data sovereignty

Storing FHIR resources directly in a pod and expecting FHIR-style queries to work is not feasible. A translation layer is required.

#### Solution: Ephemeral FHIR Service

The solution is an ephemeral (short-lived) FHIR service that:

1. Loads all relevant data from the user's pod when first accessed with a given access token
2. Provides a full FHIR R4 API with search capabilities
3. Persists changes immediately to the pod on write operations
4. Has a lifecycle bound to the pod access token (`expires_in`)
5. Can be safely deprovisioned when the token expires (stateless design)

The key insight is that the ephemeral service instance is **bound to the pod access token**. The token's `expires_in` value determines the service instance lifetime, and the `jti` (JWT ID) or token hash serves as the instance identifier.

#### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         User's Environment                                  │
│                                                                             │
│   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐                       │
│   │   App A     │   │   App B     │   │   App C     │                       │
│   │ (Welldata)  │   │ (Zipster)   │   │ (Selfcare)  │                       │
│   └──────┬──────┘   └──────┬──────┘   └──────┬──────┘                       │
│          │                 │                 │                              │
│          └─────────────────┼─────────────────┘                              │
│                            │                                                │
│                            ▼                                                │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │              Ephemeral FHIR Service (Shared Instance)               │   │
│   │                                                                     │   │
│   │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────┐  │   │
│   │  │  FHIR REST API  │  │  In-Memory      │  │  RDF Transformer    │  │   │
│   │  │  (R4 compliant) │  │  Resource Store │  │  (FHIR RDF ↔ JSON)  │  │   │
│   │  └─────────────────┘  └─────────────────┘  └─────────────────────┘  │   │
│   │                                                                     │   │
│   │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────┐  │   │
│   │  │ Capability      │  │  Search Index   │  │  Version Manager    │  │   │
│   │  │ Statement       │  │  (in-memory)    │  │  (conflict detect)  │  │   │
│   │  └─────────────────┘  └─────────────────┘  └─────────────────────┘  │   │
│   └───────────────────────────────┬─────────────────────────────────────┘   │
│                                   │                                         │
│               ┌───────────────────┴───────────────────┐                     │
│               │                                       │                     │
│               ▼ Load (session start)                  ▼ Persist (on write)  │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                        Solid Pod (RDF/Turtle)                       │   │
│   │                                                                     │   │
│   │   <pod>/weare/fhir/Patient/                                         │   │
│   │   <pod>/weare/fhir/Observation/                                     │   │
│   │   <pod>/weare/fhir/Questionnaire/                                   │   │
│   │   <pod>/weare/fhir/QuestionnaireResponse/                           │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Supported FHIR Resources

The ephemeral FHIR service supports the WellData profiles as defined in this implementation guide:

| Resource | Profile | Pod Location |
|----------|---------|--------------|
| Patient | [WellDataPatient](StructureDefinition-WellDataPatient.html) | `<pod>/weare/fhir/Patient/<uuid>.ttl` |
| Observation | [WellDataObservation](StructureDefinition-WellDataObservation.html) | `<pod>/weare/fhir/Observation/<uuid>.ttl` |
| Questionnaire | [WellDataQuestionnaire](StructureDefinition-WellDataQuestionnaire.html) | `<pod>/weare/fhir/Questionnaire/<uuid>.ttl` |
| QuestionnaireResponse | [WellDataQuestionnaireResponse](StructureDefinition-WellDataQuestionnaireResponse.html) | `<pod>/weare/fhir/QuestionnaireResponse/<uuid>.ttl` |

#### Data Storage Format

Data is stored in the pod using the [official FHIR RDF representation](https://www.hl7.org/fhir/rdf.html). This ensures:

- Standard, well-documented format
- Tooling availability for transformation
- Future compatibility with FHIR evolution

Example Observation in Turtle format (as stored in pod):

```turtle
@prefix fhir: <http://hl7.org/fhir/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<urn:uuid:obs-weight-001> a fhir:Observation ;
    fhir:meta [
        fhir:versionId [ fhir:v "1" ] ;
        fhir:lastUpdated [ fhir:v "2024-03-15T10:30:00Z"^^xsd:dateTime ]
    ] ;
    fhir:status [ fhir:v "final" ] ;
    fhir:code [
        fhir:coding [
            fhir:system [ fhir:v "http://snomed.info/sct" ] ;
            fhir:code [ fhir:v "27113001" ] ;
            fhir:display [ fhir:v "Body weight" ]
        ]
    ] ;
    fhir:subject [
        fhir:reference [ fhir:v "Patient/patient-001" ]
    ] ;
    fhir:effectiveDateTime [ fhir:v "2024-03-15T10:30:00Z"^^xsd:dateTime ] ;
    fhir:valueQuantity [
        fhir:value [ fhir:v "70"^^xsd:decimal ] ;
        fhir:unit [ fhir:v "kg" ]
    ] .
```

#### Service Lifecycle

The ephemeral FHIR service lifecycle is directly bound to the pod access token. Each unique token creates its own service instance.

##### Instance Identity

The service instance is identified by:

1. **`jti` (JWT ID)**: If the access token contains a `jti` claim, this is used as the instance identifier
2. **Token hash**: If no `jti` is available, a SHA-256 hash of the token is used

This ensures that:
- The same token always maps to the same instance
- Different tokens (even for the same user) create separate instances
- Token refresh creates a new instance

##### 1. Service Initialization

When a request arrives with a pod access token:

1. **Instance Lookup**: Check if an instance exists for this token (`jti` or hash)
2. **If new token**: Create new instance and load data from pod:
   - Enumerate all `.ttl` files in each resource container
   - Parse RDF/Turtle to FHIR RDF model
   - Transform to FHIR JSON representation
   - Populate in-memory store and search indices
   - Set instance expiry to token's `exp` claim (or current time + `expires_in`)
3. **If existing token**: Reuse the existing instance
4. **Service Ready**: Process the FHIR request

{::nomarkdown}
{% include ephemeral-fhir-init.svg %}
{:/}

##### 2. Read Operations

Read operations are served entirely from the in-memory store:

- `GET /Patient/[id]` - Direct lookup
- `GET /Observation?subject=Patient/[id]` - Search via in-memory index
- `GET /Observation?code=27113001` - Code-based search

This provides fast response times and full FHIR search parameter support.

##### 3. Write Operations (Create, Update, Delete)

Write operations follow a write-through pattern:

1. **Validate**: Ensure resource conforms to WellData profile
2. **Update In-Memory**: Apply change to in-memory store
3. **Transform to RDF**: Convert FHIR JSON to FHIR RDF/Turtle
4. **Persist to Pod**: Write `.ttl` file to appropriate container
5. **Confirm**: Return success to client

{::nomarkdown}
{% include ephemeral-fhir-write.svg %}
{:/}

##### 4. Service Termination

The service instance is terminated when:

- **Token expires**: The `exp` claim time is reached
- **Explicit cleanup**: A background process removes expired instances

The service can be safely terminated at any time because:

- All writes are immediately persisted to the pod
- No data is lost on termination
- A new token will create a fresh instance by reloading from the pod

This is similar to a Java `WeakReference` pattern: the in-memory data can be garbage collected, but the authoritative data in the pod remains.

##### 5. Token Refresh

When a client refreshes their access token:

1. A **new service instance** is created for the new token
2. The old instance continues until its token expires
3. Both instances see the same pod data (writes are persisted immediately)
4. The FHIR endpoint URL remains the same; only the internal instance changes

This approach is simpler than tracking token lineage and ensures a clean state on refresh.

#### Version Management and Conflict Detection

Each FHIR resource includes `meta.versionId` and `meta.lastUpdated` fields. These are used for optimistic concurrency control:

##### Version Tracking

- On load: Record `versionId` and `lastUpdated` for each resource
- On update: Increment `versionId`, update `lastUpdated`
- On persist: Store version metadata in RDF

##### Conflict Detection

If data in the pod is modified outside the FHIR service (e.g., by another pod application):

1. **Detection**: When reading from pod, compare `versionId`/`lastUpdated` with in-memory version
2. **Conflict**: If pod version differs from expected, a conflict is detected
3. **Resolution**:
   - Throw an error to the client application
   - Reload data from pod to synchronize state
   - Application can retry the operation

```
HTTP/1.1 409 Conflict
Content-Type: application/fhir+json

{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "conflict",
    "diagnostics": "Resource version mismatch. Pod version: 3, Expected: 2. Data has been reloaded."
  }]
}
```

#### Multi-Application Sharing

Multiple applications can share a FHIR service instance if they use the same access token.

##### Service Discovery

Applications discover the FHIR service endpoint through:

1. **WebID Document**: The user's WebID can include a link to their FHIR service endpoint
2. **Pod-relative URL**: A well-known location relative to the pod URL
3. **Configuration**: Provided during the authentication/authorization flow

Example WebID document extension:

```turtle
@prefix solid: <http://www.w3.org/ns/solid/terms#> .
@prefix welldata: <https://gidsopenstandaarden.github.io/welldata#> .

<#me> welldata:fhirEndpoint <https://fhir.example.com/user123/r4> .
```

##### Sharing Model

The sharing behavior is determined by token usage:

| Scenario | Behavior |
|----------|----------|
| Same token, multiple apps | Share the same instance |
| Different tokens, same user | Separate instances (both see same pod data) |
| Token refresh | New instance created |

Applications that need to share an instance should coordinate to use the same access token. This is typically the case when:
- A frontend and backend share a token
- Multiple microservices act on behalf of the same session

##### Memory Management

Memory management is simplified by binding to token lifetime:

- Instance expiry is set to the token's `exp` claim
- A background process periodically removes expired instances
- No reference counting or idle timeout logic needed
- Maximum memory usage is bounded by: `max_concurrent_tokens × avg_data_size`

#### Authentication and Authorization

The FHIR service uses the pod access token directly - no separate authentication is needed.

##### Token-Based Access

The pod access token serves as both:
1. **Authentication**: Proves the identity of the requestor
2. **Authorization**: Defines what pod resources can be accessed
3. **Instance binding**: Determines which FHIR service instance to use

{::nomarkdown}
{% include ephemeral-fhir-auth.svg %}
{:/}

##### How It Works

1. Client obtains pod access token via standard flow (see [Pod Access](pod-access.html))
2. Client sends FHIR request with `Authorization: Bearer <token>`
3. FHIR service extracts `jti` (or computes hash) to find/create instance
4. FHIR service uses the same token for pod operations
5. Token scope determines accessible FHIR resources

##### Authorization Scope

The FHIR service respects the same access controls as direct pod access:

- If the token grants access to `/weare/fhir/Observation/`, the client can read/write Observations via FHIR
- Container-level permissions in the pod translate to resource-type-level permissions in FHIR
- Attempting to access resources outside the token's scope returns `403 Forbidden`

#### CapabilityStatement

The FHIR service publishes a CapabilityStatement describing its capabilities:

```json
{
  "resourceType": "CapabilityStatement",
  "status": "active",
  "date": "2024-03-15",
  "kind": "instance",
  "fhirVersion": "4.0.1",
  "format": ["json", "xml"],
  "rest": [{
    "mode": "server",
    "resource": [
      {
        "type": "Patient",
        "profile": "https://gidsopenstandaarden.github.io/welldata-implementation-guide/StructureDefinition/WellDataPatient",
        "interaction": [
          { "code": "read" },
          { "code": "vread" },
          { "code": "update" },
          { "code": "delete" },
          { "code": "create" },
          { "code": "search-type" }
        ],
        "searchParam": [
          { "name": "_id", "type": "token" },
          { "name": "identifier", "type": "token" },
          { "name": "name", "type": "string" },
          { "name": "birthdate", "type": "date" }
        ]
      },
      {
        "type": "Observation",
        "profile": "https://gidsopenstandaarden.github.io/welldata-implementation-guide/StructureDefinition/WellDataObservation",
        "interaction": [
          { "code": "read" },
          { "code": "vread" },
          { "code": "update" },
          { "code": "delete" },
          { "code": "create" },
          { "code": "search-type" }
        ],
        "searchParam": [
          { "name": "_id", "type": "token" },
          { "name": "subject", "type": "reference" },
          { "name": "code", "type": "token" },
          { "name": "date", "type": "date" },
          { "name": "status", "type": "token" }
        ]
      },
      {
        "type": "Questionnaire",
        "profile": "https://gidsopenstandaarden.github.io/welldata-implementation-guide/StructureDefinition/WellDataQuestionnaire",
        "interaction": [
          { "code": "read" },
          { "code": "search-type" }
        ],
        "searchParam": [
          { "name": "_id", "type": "token" },
          { "name": "identifier", "type": "token" },
          { "name": "name", "type": "string" },
          { "name": "status", "type": "token" }
        ]
      },
      {
        "type": "QuestionnaireResponse",
        "profile": "https://gidsopenstandaarden.github.io/welldata-implementation-guide/StructureDefinition/WellDataQuestionnaireResponse",
        "interaction": [
          { "code": "read" },
          { "code": "vread" },
          { "code": "update" },
          { "code": "delete" },
          { "code": "create" },
          { "code": "search-type" }
        ],
        "searchParam": [
          { "name": "_id", "type": "token" },
          { "name": "questionnaire", "type": "reference" },
          { "name": "subject", "type": "reference" },
          { "name": "author", "type": "reference" },
          { "name": "authored", "type": "date" },
          { "name": "status", "type": "token" }
        ]
      }
    ]
  }]
}
```

#### Implementation Considerations

##### Technology Stack Options

The ephemeral FHIR service can be implemented using various technologies:

| Option | Description | Considerations |
|--------|-------------|----------------|
| HAPI FHIR | Java-based FHIR server | Mature, full-featured, JPA or in-memory store |
| Medplum | TypeScript FHIR platform | Modern, cloud-native design |
| Custom Implementation | Purpose-built for WellData | Minimal footprint, optimized for use case |

##### Deployment Models

1. **PDS-Integrated**: Pod provider hosts the FHIR service as a feature
2. **Sidecar**: FHIR service runs alongside each application
3. **Shared Service**: Central FHIR service with multi-tenant support
4. **Client-Side**: FHIR service runs in browser (WebAssembly)

##### Performance Considerations

- **Initial Load**: Loading all data at session start may take time for large datasets
- **Memory Usage**: In-memory store size grows with data volume
- **Indexing**: Search indices consume additional memory but enable fast queries

Optimization strategies:
- Lazy loading of resource types
- LRU cache for less-frequently accessed resources
- Pagination support for large result sets

#### Security Considerations

##### Data in Transit

- All communication uses TLS 1.3
- FHIR service endpoint must be HTTPS

##### Data at Rest

- In-memory data is cleared on service termination
- No persistent caching of FHIR data outside the pod
- Pod encryption is responsibility of pod provider

##### Access Control

- Token validation on every request
- Resource-level access control inherited from pod permissions
- Audit logging of all operations (see [Audit Logging](logging.html))

#### Future Extensions

##### Subscription Support

Future versions may support FHIR Subscriptions to notify applications of changes:

- WebSocket notifications when pod data changes
- Integration with pod notification mechanisms

##### Bulk Operations

Support for FHIR Bulk Data Export:

- Export all patient data in NDJSON format
- Useful for research data extraction (see [Research Data](technical-research-data.html))

##### GraphQL Support

FHIR R4 includes GraphQL support:

- More flexible queries than REST search
- Reduced round-trips for complex data needs
