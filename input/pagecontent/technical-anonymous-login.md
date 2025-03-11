## Interaction overview

The OAuth 2.0 Authorization Framework is documented in https://datatracker.ietf.org/doc/html/rfc6749, the MS Auth
middleware makes use of the Authorization Code Grant flow as described in section 4.1. Please do read the specification
to understand the workings of this flow. The diagram below denotes the steps required to perform the flow. In short, the
flow can be described as follows:

* The user agent is redirected to the authorization endpoint.
* The user performs the interaction with the middleware.
* The user agent is redirected back to the application with a code.
* The application requests an access token and identity token with the corresponding code and client id and secret.

## Step by step technical walkthrough

Although well documented by the OAuth 2 specification, the step by step walkthrough below could help the developer
understand the integration with the middleware.

### Prerequisites

The application developer should provide a redirect_uri value to the VKN operations team, the VKN operations team should
provide the application developer with a client_id and client_secret.

### Step 0, discovery.

The first step is optional.
This requests looks like the following:

```http
GET https://ms-auth.sns.gidsopenstandaarden.org/.well-known/openid-configuration HTTP/1.1
```

A typical response looks like the following.

```json
{
  "issuer": "did:web:ms-auth.sns.gidsopenstandaarden.org",
  "authorization_endpoint": "https://ms-auth.sns.gidsopenstandaarden.org/oidc/authorize",
  "token_endpoint": "https://ms-auth.sns.gidsopenstandaarden.org/oidc/token",
  "token_endpoint_auth_methods_supported": [
    "client_secret_basic",
    "client_secret_post"
  ],
  "jwks_uri": "https://ms-auth.sns.gidsopenstandaarden.org/.well-known/jwks.json",
  "scopes_supported": [
    "openid",
    "vp_uzi"
  ],
  "response_types_supported": [
    "code",
    "id_token"
  ],
  "id_token_signing_alg_values_supported": [
    "ES256K",
    "ES256",
    "RS256"
  ]
}
```

The response contains the URLs and other settings that are used in the later steps

### Step 1: authorize

To start the authorization, the user must be redirected to the following location.

```http
GET http://ms-auth.sns.gidsopenstandaarden.org/oidc/authorize?response_type=code&client_id=x&redirect_uri=y&state=x&
  scope=openid HTTP/1.1
```

The attributes are the following:

|   Attribute   | Description                                                                                                      |
|:-------------:|------------------------------------------------------------------------------------------------------------------|
| response_type | Always `code`                                                                                                    |
|   client_id   | The provided client_id                                                                                           |
| redirect_uri  | The value for the redirect_uri as exchanged with the VKN operations team.                                        |
|     scope     | The fixed value `openid`                                                                                         |
|     state     | OPTIONAL and RECOMMENDED. An opaque value used by the client to maintain state between the request and callback. |

### Step 2. the user redirects back to the redirect_uri location

```http
GET <redirect_uri>?code=x&state=y HTTP/1.1
```

The application should verify if the value of state matches the corresponding value.

### Step 3, request the access token and id token

```http
POST http://ms-auth.sns.gidsopenstandaarden.org/oidc/token HTTP/1.1
```

The request has the following application/x-www-form-urlencoded attributes as body:

|   Attribute   | Description                                                               |
|:-------------:|---------------------------------------------------------------------------|
|  grant_type   | Always `authorization_code`                                               |
|     code      | The provided code                                                         |
|   client_id   | The provided client_id                                                    |
| client_secret | Only required if the client_secret_post authentication method is used.    |
| redirect_uri  | The value for the redirect_uri as exchanged with the VKN operations team. |

#### Authorization
This request needs to be authorized with the client_id and client_secret. Currently, the following ways of authorization are supported:

*client_secret_basic* - the client_id and client_secret are encoded in the Authorization header by means of BASIC encoding.

*client_secret_post* - the client_id and client_secret are part of the application/x-www-form-urlencoded attributes as body.

A typical response looks like the following.
```json
{
  "access_token" : "...",
  "id_token": "..."
}
```

### Step 4, unpack and validate the id_token.
The id_token is a JWT token that must be unpacked and validated. This procedure is supported by libraries in almost all available platforms. The public key that is required to validate the token can be found at the jwks_uri of the discovery step. The contents of the token contains the user identification as the sub field.

```JSON
{
  "iss": "https://ms-auth.sns.gidsopenstandaarden.org",
  "sub": "<user_id>",
  "aud": "<client_id>",
  "exp": 1311281970,
  "iat": 1311280970,
  "nonce": "..."
}
```

There are some validations that must be done on the token. Being:
* The token must be validated with the corresponding public key published at jwks_uri.
* The issuer must be the middleware application base URL.
* The audience must be the client_id of your application.
* The exp time must be checked for expiration.
* The nonce must be used to prevent replay attacks.
