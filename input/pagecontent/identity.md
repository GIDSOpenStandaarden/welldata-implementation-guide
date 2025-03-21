### WebId

The [WebID](https://www.w3.org/2005/Incubator/webid/spec/identity/) is a decentralized identification standard that enables individuals and organizations to establish a unique, verifiable identity on the web. It is built upon Linked Data principles and typically represented as a URI (Uniform Resource Identifier) pointing to a publicly accessible profile document. 

### SOLID-OIDC
Authentication of the users in Welldata is based on the SOLID-OIDC specification. It defines how owners of the pods need to authenticate towards an IDP and how resource servers can verify the identity of pod owners based on that authentication.
The SOLID-OIDC flow is described in detail [here](https://solidproject.org/TR/oidc-primer#solid-oidc-flow)

The SOLID-OIDC flow is based on the [OIDC flow](https://openid.net/specs/openid-connect-core-1_0.html).

### Client Credentials OAUTH 2.0 Flow

In Solid each agent has a [WebId](https://dvcs.w3.org/hg/WebID/raw-file/tip/spec/identity-respec.html) associated with it. The WebId contains information on how the agent can authenticate itself. In We Are application agents are registered in the We Are IDP. This is an IDP specifically for applications, which allows applications to identify themselves. Clients are authorized via the [client credentials flow](https://datatracker.ietf.org/doc/html/rfc6749#section-1.3.4) to receive an access token. 

{::nomarkdown}
{% include client-credentials.svg %}
{:/}

The token endpoint is called with the following parameters:

- grant_type: `client_credentials`
- client_id: the client Id from the application registered in the We Are IDP
- client_secret: accompanying secret for the client Id

In order to access the resource in the pod, the client needs to exchange it's token for yet another token by calling the [UMA service of Inrupt](https://docs.inrupt.com/archive/ess/2.1/services/service-uma/).


### GIDS Anonymous Login
[GIDS Anonymous Login](identity-anonymous-login.html)
