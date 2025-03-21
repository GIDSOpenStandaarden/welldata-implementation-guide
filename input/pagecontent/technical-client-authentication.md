
In order for applications to access pod resources, they need to authenticate themselves and receive an access token and id token to be used to exchange for another access token, with which they can access the pod. Each application has a [WebId](https://dvcs.w3.org/hg/WebID/raw-file/tip/spec/identity-respec.html) associated with it.  In We Are application are registered in the We Are IDP. This is an IDP specifically for applications, which allows applications to identify themselves. Clients are authorized via the [client credentials flow](https://datatracker.ietf.org/doc/html/rfc6749#section-1.3.4) to receive an access token. 

{::nomarkdown}
{% include client-credentials.svg %}
{:/}

The token endpoint is called with the following parameters:

- grant_type: `client_credentials`
- client_id: the client Id from the application registered in the We Are IDP
- client_secret: accompanying secret for the client Id

In order to access the resource in the pod, the client needs to exchange it's token for yet another token by calling the [UMA service of Inrupt](https://docs.inrupt.com/archive/ess/2.1/services/service-uma/).

In the [We Are Demo backend application](https://github.com/VITObelgium/We-Are-Demo-Back-End) the client credentials flow is automatically executed and uses the following environment variables:

```
WEARE_OIDC_CLIENT_ID
WEARE_OIDC_CLIENT_SECRET
```
