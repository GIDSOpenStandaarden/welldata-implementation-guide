### Compose a launch

#### 0. Pre-requisites

The launching party should have a public-private keypair, with the public key available by openid-configuration method:

* A keypair should be generated, see the section [Generating a keypair](#generating-a-keypair)
* The application should have endpoints according to
  the [OpenID Connect Discovery 1.0](https://openid.net/specs/openid-connect-discovery-1_0.html) specification.
  * The <base-url>/.well-known/openid-configuration` should have at least:
    * The `issuer` value matching the <base-url>
    * The `jwks_uri` matching the JWKS endpoint.
  * The JWKS endpoint having the public key as JWK available.

##### Generating a keypair:

```shell
ssh-keygen -t rsa -m PKCS8 -b 2048 -f private.key
openssl rsa -in private.key -pubout -outform PEM -out public.key

printf "Private key:\n\n"
cat private.key
printf "\nPublic key:\n\n"
cat public.key
printf "\n"
```

To perform the launch, the following steps must be performed:

#### 1. Create HTI context claims

The HTI:core v2.0 profile describes the following claims:

| HTI claim    | Type      | Required | The identifier of the task to be executed by the person in the sub field. |
|--------------|-----------|----------|---------------------------------------------------------------------------|
| `resource`   | string    | yes      | The identifier of the task to be executed by the person in the sub field. |
| `definition` | url       | no       | The URL of the module definition                                          |
| `sub`        | reference | yes      | The Web-ID of the person executing the launch.                            |
| `patient`    | string    | no       | The Web-ID of the patient involved in the launch if it is not the `sub`.  |

An example of the resulting HTI claims

```json
{
  "resource": "5f684c5f-2837-4505-a534-365431912f37",
  "definition": "https://example.com/my-questionnaire",
  "sub": "https://example.com/web-id/2312312312"
}
```

#### 2. Create the JWT

The HTI:core v2.0 profile also contains claims that are always set on a JWT:

| Description       | Field | Value                                                                                                                                                                                                                                                                                             |
|-------------------|-------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Issuer            | iss   | The base URL of the launching application.                                                                                                                                                                                                                                                        |
| Audience          | aud   | The base URL of the target application.                                                                                                                                                                                                                                                           |
| Unique message id | jti   | A unique identifier for this message. This value **MUST** be treated as a NONCE, a subsequent message with an identical jti **MUST** be rejected. The jti value must be a random or pseudo number, the jti **MUST** contain enough entropy to block brute-force attacks.                          |
| Issue time        | iat   | The timestamp of generating the JWT token, the value of this field **MUST** be validated by the module provider to not be in the future.                                                                                                                                                          |
| Expiration time   | exp   | The "exp" (expiration time) claim identifies the expiration time on or after which the JWT **MUST** NOT be accepted for processing. The value **MUST** be limited to 5 minutes. This value **MUST** be validated by the module provider, any value that exceeds the timeout **MUST** be rejected. |

These two sets of claims should be combined to form a valid HTI v2.0 JWT. For example:

```JSON
{
  "iat": 1585564845,
  "aud": "https://module.example.com/module1",
  "iss": "https://portal.example.com/",
  "exp": 1585565745,
  "jti": "679e1e4c-bcb9-4fcc-80c4-f36e7063545c",
  "sub": "https://example.com/web-id/2312312312",
  "resource": "5f684c5f-2837-4505-a534-365431912f37",
  "definition": "https://example.com/my-questionnaire"
}
```

The timestamps follows the [UNIX time](https://en.wikipedia.org/wiki/Unix_time) convention, being the number of seconds
since the epoch.

#### 3. Sign the JWT

The JWT should be signed in the [JWS compact serialization](https://datatracker.ietf.org/doc/html/rfc7515#section-3.1).

#### 3. Initiating a launch

The launch can be initiated via a <form> and the form-post-redirect flow.

##### Headers

| Name         | Type   | Description                         |
|--------------|--------|-------------------------------------|
| Content-Type | String | `application/x-www-form-urlencoded` |

##### Request Body

| Name   | Type   | Description    |
|--------|--------|----------------|
| launch | String | The signed JWT |

##### Example:

```html

<html>
<head>
</head>
<body onload="document.forms[0].submit();">
<form action="https://module.provider.eu/modules/x" method="post">
  <input type="hidden" name="launch" value="eyJhbGciO..."/>
</form>
</body>
</html>
```
