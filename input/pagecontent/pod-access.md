Access in a Solid pod of a user can only be accessed when the application has a proper access grant. In order to get an access grant, the application needs to be identified by a WebID. For that we created a We Are IDP, which has a client credentials token endpoint to get tokens for applications and use the tokens to construct access grants for. 

### Access Requests

An [access request](https://docs.inrupt.com/developer-tools/javascript/client-libraries/tutorial/manage-access-requests-grants/) is a verifiable credentials where the request for access is captured of an application with a webId to a specific resource of a pod owner. 

The call to create an access request is done by the application with the access token, it received from the We Are IDP, as `Authorization: Bearer` header, to the `\issue` endpoint of the [Inrupt VC service](https://docs.inrupt.com/ess/latest/services/service-access-grant-issuer/).

{::nomarkdown}
{% include access-request.svg %}
{:/}

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

{::nomarkdown}
{% include pod-access.svg %}
{:/}
