Access in a Solid pod of a user can only be accessed when the application has a proper access grant. In order to get an access grant, the application needs to be identified by a WebID. For that we created a We Are IDP, which has a client credentials token endpoint to get tokens for applications and use the tokens to construct access grants for. 

### Client Application Authenticateion

In Solid each agent has a [webId](https://dvcs.w3.org/hg/WebID/raw-file/tip/spec/identity-respec.html) associated with it. THe webId contains information on how the agent can authenticate itself. In We Are application agents are registered in the We Are IDP. This is an IDP specifically for applications, which allows applications to identify themselves. Clients are authorized via the [client credentials flow](https://datatracker.ietf.org/doc/html/rfc6749#section-1.3.4) to receive an access token. 

{% include client-credentials.svg %}

The token endpoint is called with the following parameters:

- grant_type: `client_credentials`
- client_id: the client Id from the application registered in the We Are IDP
- client_secret: accompanying secret for the client Id

In order to access the resource in the pod, the client needs to exchange it's token for yet another token by calling the [UMA service of Inrupt](https://docs.inrupt.com/archive/ess/2.1/services/service-uma/).


### Access Requests

An [access request](https://docs.inrupt.com/developer-tools/javascript/client-libraries/tutorial/manage-access-requests-grants/) is a verifiable credentials where the request for access is captured of an application with a webId to a specific resource of a pod owner. 

THe call to create an access request is done by the application with the access token it received from the We Are IDP to the `\issue` endpoint of the [Inrupt VC service](https://docs.inrupt.com/ess/latest/services/service-access-grant-issuer/).

{% include access-request.svg %}

The body of the call should contain a valid Access Request form:

```
{
  "credential": {
    "@context": [
      "https://www.w3.org/2018/credentials/v1",
      "https://schema.inrupt.com/credentials/v1.jsonld"
    ],
    "credentialSubject": {
      "hasConsent": {
        "mode": <Access Mode URL | Array of Access Mode URLs>,
        "hasStatus": "https://w3id.org/GConsent#ConsentStatusRequested",
        "isConsentForDataSubject": <Resource Owner WebID>,
        "forPersonalData": <Resource URL | Array of Resource URLS>,
        "inherit": <Optional. true|false>
      }
    }
  }
}

```

### Access Grants

The pod owner can be redirected to the We Are Ama with the access request. There the user can approve or reject the request. Upon approval an access grant is created for the client application. This access grant is tied to the WebId of the application and can be used by the application to get access to the defined resource that is in the access grant.

```
{
  "credential": {
    "@context": [
      "https://www.w3.org/2018/credentials/v1",
      "https://schema.inrupt.com/credentials/v1.jsonld"
    ],
    "credentialSubject": {
      "providedConsent": {
        "mode": <Access Mode IRI | Array of Access Mode IRIs>,
        "hasStatus": "https://w3id.org/GConsent#ConsentStatusExplicitlyGiven",
        "forPersonalData": <ResourceIRI | Array of Resource IRIS>,
        "isProvidedTo": <WebID>,
        "inherit": <Optional. true|false>
      }
    }
  }
}
```

### Accessing data in the pod with an Access Grant

A resource can be fetched from the pod by providing an access token in the `Authorization Bearer` header. The client application has an access grant for access the resource. This access grant needs to be transformed in an access token. This is done via the [UMA](https://docs.kantarainitiative.org/uma/wg/rec-oauth-uma-grant-2.0.html#protocol-flow-details-sec) flow by calling the [UMA service endpoint](https://docs.inrupt.com/ess/latest/services/service-uma/) of Inrupt.

First a call needs to be made to the resource endpoint. It will return two headers:
- UMA as_uri: uri of the UMA endpoint
- ticket: the ticket number to be used in the UMA call to exchange the access grant for an access token.

Then the UMA endpoint is called with the following parameters:
- grant_type = `urn:ietf:params:oauth:grant-type:uma-ticket`
- ticket = the ticket received by calling the resource endpoint
- claim_token= This is the Base64 encoded Access Grant
- claim_token_format=`https://www.w3.org/TR/vc-data-model/#json-ld`

The flow is described below in the diagram:

{% include pod-access.svg %}
